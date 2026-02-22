"use client";

/**
 * SmartAuthLink — renders a CTA button/link that:
 *  - If user is already logged in AND is the right role  → goes to their dashboard
 *  - If user is logged in but WRONG role                 → shows a conflict message
 *  - If user is NOT logged in                            → goes to the auth page
 *
 * Usage:
 *   <SmartAuthLink role="talent"  loggedInHref="/talent/dashboard"  guestHref="/auth?view=signup&role=talent"  className="...">Join as Developer</SmartAuthLink>
 *   <SmartAuthLink role="startup" loggedInHref="/startup/dashboard" guestHref="/startup/dashboard/login?view=signup" className="...">Post First Drop</SmartAuthLink>
 */

import { useEffect, useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

const STARTUP_ROLES = ["Founder", "Co-Founder", "CTO", "VP of Engineering", "Head of Product", "Product Manager", "Engineering Lead"];

type Props = {
    role: "talent" | "startup";
    loggedInHref: string;
    guestHref: string;
    className?: string;
    children: React.ReactNode;
};

export default function SmartAuthLink({ role, loggedInHref, guestHref, className = "", children }: Props) {
    const [href, setHref] = useState(guestHref); // default to guest flow
    const [checked, setChecked] = useState(false);

    useEffect(() => {
        const supabase = createClient();

        async function resolveHref() {
            const { data: { user } } = await supabase.auth.getUser();

            if (!user) {
                setHref(guestHref);
                setChecked(true);
                return;
            }

            // Fetch profile role
            const { data: profile } = await supabase
                .from("profiles")
                .select("role")
                .eq("id", user.id)
                .single();

            const dbRole = profile?.role;
            const metaRole = user.user_metadata?.user_type;
            const isStartup = (dbRole && STARTUP_ROLES.includes(dbRole)) || metaRole === "startup";

            if (role === "talent") {
                // Talent CTA: logged-in talent → dashboard, startup → still send to talent login (they'll see conflict)
                setHref(isStartup ? guestHref : loggedInHref);
            } else {
                // Startup CTA: logged-in startup → dashboard, talent → still send to startup login (they'll see conflict)
                setHref(isStartup ? loggedInHref : guestHref);
            }

            setChecked(true);
        }

        resolveHref();
    }, [role, loggedInHref, guestHref]);

    // Render a placeholder skeleton while checking (prevents flash of wrong link)
    if (!checked) {
        return (
            <span className={`${className} opacity-50 pointer-events-none`}>
                {children}
            </span>
        );
    }

    return (
        <Link href={href} className={className}>
            {children}
        </Link>
    );
}
