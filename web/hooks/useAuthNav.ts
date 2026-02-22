"use client";

/**
 * useAuthNav — shared hook that resolves WHERE a CTA button should navigate.
 *
 * Returns:
 *   status: "loading" | "guest" | "correct-role" | "wrong-role"
 *   destination: string  — href to navigate to
 *   userRole: "startup" | "talent" | null
 */

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { isStartupRole } from "@/lib/auth/roles";

export type AuthNavStatus = "loading" | "guest" | "correct-role" | "wrong-role";

export type AuthNavResult = {
    status: AuthNavStatus;
    destination: string;
    userRole: "startup" | "talent" | null;
    userName: string | null;
};

export function useAuthNav(
    intendedRole: "talent" | "startup",
    loggedInHref: string,
    guestHref: string
): AuthNavResult {
    const [result, setResult] = useState<AuthNavResult>({
        status: "loading",
        destination: guestHref,
        userRole: null,
        userName: null,
    });

    useEffect(() => {
        let cancelled = false;
        const supabase = createClient();

        async function resolve() {
            const { data: { user } } = await supabase.auth.getUser();

            if (cancelled) return;

            if (!user) {
                setResult({ status: "guest", destination: guestHref, userRole: null, userName: null });
                return;
            }

            // Resolve role from metadata (fast path) or DB (slow path)
            const metaRole: string = user.user_metadata?.role ?? user.user_metadata?.start_role ?? "";
            const metaType: string = user.user_metadata?.user_type ?? "";
            let actualRole: "startup" | "talent";

            if (metaType === "startup" || isStartupRole(metaRole)) {
                actualRole = "startup";
            } else if (metaRole !== "" && !isStartupRole(metaRole)) {
                actualRole = "talent";
            } else {
                // Slow path — check profiles table
                const { data: profile } = await supabase
                    .from("profiles")
                    .select("role")
                    .eq("id", user.id)
                    .maybeSingle();
                actualRole = profile?.role && isStartupRole(profile.role) ? "startup" : "talent";
            }

            if (cancelled) return;

            const userName = user.user_metadata?.full_name ?? user.email ?? null;

            if (actualRole === intendedRole) {
                setResult({ status: "correct-role", destination: loggedInHref, userRole: actualRole, userName });
            } else {
                setResult({ status: "wrong-role", destination: guestHref, userRole: actualRole, userName });
            }
        }

        resolve();
        return () => { cancelled = true; };
    }, [intendedRole, loggedInHref, guestHref]);

    return result;
}
