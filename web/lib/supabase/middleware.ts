
import { createServerClient } from "@supabase/ssr";
import { type NextRequest, NextResponse } from "next/server";
import { isStartupRole } from "@/lib/auth/roles";

export const updateSession = async (request: NextRequest) => {
    let response = NextResponse.next({
        request: {
            headers: request.headers,
        },
    });

    const supabase = createServerClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
        {
            cookies: {
                getAll() {
                    return request.cookies.getAll();
                },
                setAll(cookiesToSet) {
                    cookiesToSet.forEach(({ name, value }) =>
                        request.cookies.set(name, value)
                    );
                    response = NextResponse.next({
                        request,
                    });
                    cookiesToSet.forEach(({ name, value, options }) =>
                        response.cookies.set(name, value, options)
                    );
                },
            },
        }
    );

    // 1. Fetch User
    const {
        data: { user },
    } = await supabase.auth.getUser();

    const path = request.nextUrl.pathname;
    const isStartupDashboard = path.startsWith("/startup/dashboard");
    const isTalentDashboard = path.startsWith("/talent/dashboard");
    const isDashboard = path === "/dashboard";

    const isAuthRoute = path.startsWith("/auth") ||
        path === "/login" ||
        path === "/signup" ||
        path.includes("/login") || path.includes("/onboarding");

    // 2. Unauthenticated Guard
    if ((isStartupDashboard || isTalentDashboard || isDashboard) && !isAuthRoute && !user) {
        // Redirect to login
        if (isStartupDashboard) {
            return NextResponse.redirect(new URL("/startup/dashboard/login", request.url));
        }
        return NextResponse.redirect(new URL("/auth", request.url));
    }

    // 3. Authenticated Logic
    if (user) {
        // PERFORMANCE FIX: Check Metadata First
        let role = user.user_metadata?.start_role || user.user_metadata?.role; // Handle potential different namings

        // If no role in metadata, we might need to fetch profile (Fallback)
        // But to avoid double fetch, we will try to proceed. 
        // If CRITICAL role check is needed, we rely on the Page to fetch profile if metadata is missing.
        // However, we can also check if we have the specific "user_type" which seems to be used elsewhere.
        const userType = user.user_metadata?.user_type; // 'startup' or undefined

        // Simple Heuristic Routing
        // If visiting Startup Dashboard
        if (isStartupDashboard && !path.includes("/login")) {
            // Must be startup
            if (userType !== 'startup' && !isStartupRole(role)) {
                // If we are UNSURE (no metadata), we might let them through and let the Page block them?
                // Or we do the DB fetch HERE only if metadata is missing.
                if (!userType && !role) {
                    const { data: profile } = await supabase.from('profiles').select('role').eq('id', user.id).single();
                    if (profile) {
                        role = profile.role;
                        // Ideally we update metadata here so next time it's fast, but we can't easily in middleware without Supabase Service Key?
                        // Actually getUser returns a session, we can't update user from middleware easily without service key.
                    }
                }

                if (userType !== 'startup' && !isStartupRole(role)) {
                    // Redirect to Talent
                    return NextResponse.redirect(new URL("/talent/dashboard", request.url));
                }
            }
        }

        // If visiting Talent Dashboard
        if (isTalentDashboard) {
            if (userType === 'startup' || isStartupRole(role)) {
                return NextResponse.redirect(new URL("/startup/dashboard", request.url));
            }
        }
    }

    return response;
};
