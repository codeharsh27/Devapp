import { createServerClient } from "@supabase/ssr";
import { type NextRequest, NextResponse } from "next/server";
import { isStartupRole, isTalentRole } from "@/lib/auth/roles";

// Routes that authenticated users should not be able to re-visit
const AUTH_PATHS = ["/auth", "/login", "/signup", "/startup/dashboard/login"];
// Protected dashboard paths
const STARTUP_PREFIX = "/startup/dashboard";
const TALENT_PREFIX = "/talent/dashboard";

function isAuthPath(path: string): boolean {
    return AUTH_PATHS.some((p) => path === p || path.startsWith(p + "/"));
}

export const updateSession = async (request: NextRequest) => {
    // We create a mutable response so that cookie refreshes are propagated.
    let response = NextResponse.next({ request: { headers: request.headers } });

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
                    response = NextResponse.next({ request });
                    cookiesToSet.forEach(({ name, value, options }) =>
                        response.cookies.set(name, value, options)
                    );
                },
            },
        }
    );

    // ── 1. Resolve the authenticated user ───────────────────────────────────
    const {
        data: { user },
    } = await supabase.auth.getUser();

    const path = request.nextUrl.pathname;
    const isStartupDash = path.startsWith(STARTUP_PREFIX);
    const isTalentDash = path.startsWith(TALENT_PREFIX);
    const isProtected = isStartupDash || isTalentDash;

    // ── 2. Unauthenticated guard ─────────────────────────────────────────────
    if (isProtected && !user) {
        const loginUrl = isStartupDash
            ? new URL("/startup/dashboard/login", request.url)
            : new URL("/auth", request.url);
        loginUrl.searchParams.set("next", path); // preserve intent for post-login redirect
        return NextResponse.redirect(loginUrl);
    }

    // ── 3. Redirect authenticated users away from auth pages ────────────────
    if (user && isAuthPath(path)) {
        // We don't know their role yet at this point cheaply;
        // let the onboarding/landing page handle the redirect.
        // Just prevent them from getting stuck on the login screen.
        return NextResponse.redirect(new URL("/", request.url));
    }

    // ── 4. Role-based access control for protected dashboards ───────────────
    if (user && isProtected) {
        // Fast path: role is in JWT user_metadata (set during onboarding)
        let role: string =
            user.user_metadata?.role ??
            user.user_metadata?.start_role ??   // legacy key
            "";

        const userType: string = user.user_metadata?.user_type ?? ""; // 'startup' | ''

        // Determine role category from what we already have
        let knownIsStartup = userType === "startup" || isStartupRole(role);
        let knownIsTalent = !knownIsStartup && (isTalentRole(role) || (role !== "" && !isStartupRole(role)));

        // Slow path: if metadata has no usable role, do a single DB lookup.
        // We only do this once per request; Supabase uses the same auth token
        // so this doesn't add a round-trip beyond what the page itself would do.
        if (!knownIsStartup && !knownIsTalent) {
            const { data: profile } = await supabase
                .from("profiles")
                .select("role")
                .eq("id", user.id)
                .maybeSingle();

            if (profile?.role) {
                role = profile.role;
                knownIsStartup = isStartupRole(role);
                knownIsTalent = isTalentRole(role) || !knownIsStartup;
            }
        }

        // Skip login sub-routes (e.g. /startup/dashboard/login)
        const isLoginSubroute = path.includes("/login") || path.includes("/onboarding");
        if (isLoginSubroute) return response;

        // Enforce: startup user visiting talent dashboard → redirect to startup
        if (isTalentDash && knownIsStartup) {
            return NextResponse.redirect(new URL(STARTUP_PREFIX, request.url));
        }

        // Enforce: talent user visiting startup dashboard → redirect to talent
        if (isStartupDash && knownIsTalent) {
            return NextResponse.redirect(new URL(TALENT_PREFIX, request.url));
        }
    }

    return response;
};
