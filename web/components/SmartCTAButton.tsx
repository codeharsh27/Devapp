"use client";

/**
 * SmartCTAButton — the universal CTA button for landing pages.
 *
 * Features:
 * - Checks Supabase session on mount (shows spinner while loading)
 * - Correct role logged in → goes to dashboard with page transition loader
 * - Wrong role logged in  → shows RoleConflictModal
 * - Guest               → goes to auth signup page with page transition loader
 *
 * Usage:
 *   <SmartCTAButton role="talent" loggedInHref="/talent/dashboard" guestHref="/auth?view=signup&role=talent" className="...">
 *     Join as Developer
 *   </SmartCTAButton>
 */

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2 } from "lucide-react";
import { useAuthNav } from "@/hooks/useAuthNav";
import RoleConflictModal from "@/components/RoleConflictModal";

type Props = {
    role: "talent" | "startup";
    loggedInHref: string;
    guestHref: string;
    className?: string;
    children: React.ReactNode;
    /** If true, renders as a block element (default: inline) */
    block?: boolean;
};

export default function SmartCTAButton({
    role,
    loggedInHref,
    guestHref,
    className = "",
    children,
    block = false,
}: Props) {
    const router = useRouter();
    const { status, destination, userRole, userName } = useAuthNav(role, loggedInHref, guestHref);
    const [navigating, setNavigating] = useState(false);
    const [showConflict, setShowConflict] = useState(false);

    const handleClick = () => {
        if (status === "loading") return;

        if (status === "wrong-role") {
            setShowConflict(true);
            return;
        }

        // Navigate with loading state
        setNavigating(true);
        router.push(destination);
    };

    const isLoading = status === "loading" || navigating;

    const Tag = block ? "div" : "span";

    return (
        <>
            <button
                onClick={handleClick}
                disabled={isLoading}
                className={`${className} ${block ? "flex w-full" : "inline-flex"} items-center justify-center gap-2 relative transition-opacity ${isLoading ? "opacity-70 cursor-wait" : "cursor-pointer"}`}
            >
                {isLoading ? (
                    <>
                        <Loader2 className="w-4 h-4 animate-spin shrink-0" />
                        <span className="truncate">
                            {status === "loading" ? "Checking..." : "Loading..."}
                        </span>
                    </>
                ) : (
                    children
                )}
            </button>

            {showConflict && userRole && (
                <RoleConflictModal
                    intendedRole={role}
                    actualRole={userRole}
                    userName={userName}
                    onClose={() => setShowConflict(false)}
                />
            )}
        </>
    );
}
