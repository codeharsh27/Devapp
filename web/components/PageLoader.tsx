"use client";

/**
 * PageLoader — full-screen overlay shown during route transitions.
 * Import this into layout.tsx and use NavigationEvents to trigger it.
 */

import { useEffect, useState, useCallback } from "react";
import { usePathname, useSearchParams } from "next/navigation";

export function usePageLoader() {
    const [loading, setLoading] = useState(false);
    const pathname = usePathname();
    const searchParams = useSearchParams();

    // Hide loader when the route actually changes (page mounted)
    useEffect(() => {
        setLoading(false);
    }, [pathname, searchParams]);

    const startLoading = useCallback(() => setLoading(true), []);

    return { loading, startLoading };
}

export default function PageLoader({ loading }: { loading: boolean }) {
    if (!loading) return null;

    return (
        <div className="fixed inset-0 z-[9999] bg-black/60 backdrop-blur-sm flex flex-col items-center justify-center gap-4">
            <div className="relative w-12 h-12">
                <div className="absolute inset-0 border-4 border-white/20 rounded-full" />
                <div className="absolute inset-0 border-4 border-t-white border-r-transparent border-b-transparent border-l-transparent rounded-full animate-spin" />
            </div>
            <p className="text-white text-sm font-mono uppercase tracking-widest opacity-70">
                Loading...
            </p>
        </div>
    );
}
