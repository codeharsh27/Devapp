"use client";

/**
 * RoleConflictModal — shown when a user tries to access a section
 * that doesn't match their current role.
 *
 * Renders via a React Portal into document.body to avoid being
 * clipped by parent transforms (e.g. Framer Motion navbar animations).
 */

import { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { AlertTriangle, LogOut, ArrowRight, Loader2 } from "lucide-react";

type Props = {
    intendedRole: "talent" | "startup";
    actualRole: "talent" | "startup";
    userName: string | null;
    onClose: () => void;
};

const DASHBOARD_URLS = {
    talent: "/talent/dashboard",
    startup: "/startup/dashboard",
};

const ROLE_LABELS = {
    talent: "Developer",
    startup: "Startup",
};

function ConflictModalContent({ intendedRole, actualRole, userName, onClose }: Props) {
    const router = useRouter();
    const [signingOut, setSigningOut] = useState(false);

    // Close on Escape key
    useEffect(() => {
        const onKey = (e: KeyboardEvent) => { if (e.key === "Escape") onClose(); };
        document.addEventListener("keydown", onKey);
        return () => document.removeEventListener("keydown", onKey);
    }, [onClose]);

    // Lock body scroll while open
    useEffect(() => {
        document.body.style.overflow = "hidden";
        return () => { document.body.style.overflow = ""; };
    }, []);

    const handleGoToDashboard = () => {
        onClose();
        router.push(DASHBOARD_URLS[actualRole]);
    };

    const handleSignOut = async () => {
        setSigningOut(true);
        const supabase = createClient();
        await supabase.auth.signOut();
        onClose();
        const destination =
            intendedRole === "startup"
                ? "/startup/dashboard/login?view=signup"
                : "/auth?view=signup&role=talent";
        router.push(destination);
    };

    return (
        <div
            className="fixed inset-0 flex items-center justify-center p-4"
            style={{ zIndex: 99999 }}
        >
            {/* Backdrop */}
            <div
                className="absolute inset-0 bg-black/75 backdrop-blur-sm"
                onClick={onClose}
            />

            {/* Modal card */}
            <div
                className="relative bg-[#111] border border-white/10 rounded-2xl p-8 max-w-md w-full shadow-2xl"
                onClick={(e) => e.stopPropagation()}
            >
                {/* Icon */}
                <div className="flex items-center justify-center w-14 h-14 bg-amber-500/10 border border-amber-500/20 rounded-full mx-auto mb-6">
                    <AlertTriangle className="w-7 h-7 text-amber-400" />
                </div>

                <h2 className="text-xl font-bold text-white text-center mb-2">
                    Account Mismatch
                </h2>

                <p className="text-gray-400 text-sm text-center mb-6 leading-relaxed">
                    You&apos;re signed in as a{" "}
                    <span className="text-white font-semibold">{ROLE_LABELS[actualRole]}</span>
                    {userName && (
                        <span className="text-gray-500"> ({userName})</span>
                    )}
                    , but this section is for{" "}
                    <span className="text-white font-semibold">{ROLE_LABELS[intendedRole]}s</span>.
                </p>

                <div className="space-y-3">
                    {/* Go to their actual dashboard */}
                    <button
                        onClick={handleGoToDashboard}
                        className="w-full flex items-center justify-between bg-white text-black font-bold uppercase tracking-widest text-xs px-6 py-4 rounded-lg hover:bg-gray-100 transition-colors group"
                    >
                        <span>Go to My {ROLE_LABELS[actualRole]} Dashboard</span>
                        <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                    </button>

                    {/* Sign out and switch */}
                    <button
                        onClick={handleSignOut}
                        disabled={signingOut}
                        className="w-full flex items-center justify-between border border-white/10 text-gray-300 font-bold uppercase tracking-widest text-xs px-6 py-4 rounded-lg hover:border-white/30 hover:text-white transition-colors group disabled:opacity-50 disabled:cursor-wait"
                    >
                        <span>
                            {signingOut
                                ? "Signing out…"
                                : `Switch to ${ROLE_LABELS[intendedRole]} Account`}
                        </span>
                        {signingOut ? (
                            <Loader2 className="w-4 h-4 animate-spin" />
                        ) : (
                            <LogOut className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                        )}
                    </button>
                </div>

                <p className="text-[11px] text-gray-600 text-center mt-6">
                    You&apos;ll need a separate account for each role.
                </p>
            </div>
        </div>
    );
}

export default function RoleConflictModal(props: Props) {
    const [mounted, setMounted] = useState(false);

    useEffect(() => {
        setMounted(true);
        return () => setMounted(false);
    }, []);

    // Render via portal into document.body — bypasses any parent transform
    // stacking context that would break position:fixed centering.
    if (!mounted) return null;
    return createPortal(<ConflictModalContent {...props} />, document.body);
}
