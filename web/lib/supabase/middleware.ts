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

async function resolveUserRole(
    supabase: ReturnType<typeof createServerClient>,
    user: { id: string; user_metadata: Record<string, string> }
): Promise<"startup" | "talent" | null> {
    const metaRole: string =
        user.user_metadata?.role ?? user.user_metadata?.start_role ?? "";
    const metaType: string = user.user_metadata?.user_type ?? "";

    if (metaType === "startup" || isStartupRole(metaRole)) return "startup";
    if (metaRole !== "" && !isStartupRole(metaRole)) return "talent";

    // Slow path — DB lookup
    const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .maybeSingle();

    if (!profile?.role) return null; // Onboarding not complete yet
    return isStartupRole(profile.role) ? "startup" : "talent";
}

export const updateSession = async (request: NextRequest) => {
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

    const {
        data: { user },
    } = await supabase.auth.getUser();

    const path = request.nextUrl.pathname;
    const isStartupDash = path.startsWith(STARTUP_PREFIX);
    const isTalentDash = path.startsWith(TALENT_PREFIX);
    const isProtected = isStartupDash || isTalentDash;
    const isLoginSubroute =
        path.includes("/login") ||
        path.includes("/onboarding") ||
        path.endsWith("/new-drop") ||
        path.endsWith("/jobs/create");

    // ── 1. Unauthenticated guard ─────────────────────────────────────────────
    if (isProtected && !user) {
        const loginUrl = isStartupDash
            ? new URL("/startup/dashboard/login", request.url)
            : new URL("/auth", request.url);
        loginUrl.searchParams.set("next", path);
        return NextResponse.redirect(loginUrl);
    }

    // ── 2. Redirect authenticated users away from auth pages ─────────────────
    if (user && isAuthPath(path)) {
        // Don't know their role cheaply — resolve it so we send them to the RIGHT dashboard
        const role = await resolveUserRole(supabase, user as any);
        if (role === "startup") {
            return NextResponse.redirect(new URL(STARTUP_PREFIX, request.url));
        }
        if (role === "talent") {
            return NextResponse.redirect(new URL(TALENT_PREFIX, request.url));
        }
        // Role unknown (onboarding incomplete) — send to main page to figure it out
        return NextResponse.redirect(new URL("/", request.url));
    }

    // ── 3. Role-based access control for protected dashboards ────────────────
    if (user && isProtected && !isLoginSubroute) {
        const role = await resolveUserRole(supabase, user as any);

        // Startup user visiting talent dashboard → redirect to startup
        if (isTalentDash && role === "startup") {
            return NextResponse.redirect(new URL(STARTUP_PREFIX, request.url));
        }

        // Talent user visiting startup dashboard → redirect to talent
        if (isStartupDash && role === "talent") {
            return NextResponse.redirect(new URL(TALENT_PREFIX, request.url));
        }
    }

    return response;
};
