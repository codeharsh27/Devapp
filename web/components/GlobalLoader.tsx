"use client";

/**
 * GlobalLoader — a slim top progress bar that shows on every route change.
 * Must be wrapped in <Suspense> in layout.tsx because it uses useSearchParams.
 */

import { useEffect, useRef, useState } from "react";
import { usePathname, useSearchParams } from "next/navigation";

export default function GlobalLoader() {
    const pathname = usePathname();
    const searchParams = useSearchParams();
    const [progress, setProgress] = useState(0);
    const [visible, setVisible] = useState(false);
    const timerRef = useRef<NodeJS.Timeout | null>(null);
    const prevRoute = useRef<string>(`${pathname}${searchParams}`);

    useEffect(() => {
        const currentRoute = `${pathname}${searchParams}`;

        if (currentRoute !== prevRoute.current) {
            // Route changed — finish the bar and hide
            prevRoute.current = currentRoute;
            setProgress(100);
            timerRef.current = setTimeout(() => {
                setVisible(false);
                setProgress(0);
            }, 400);
        }

        return () => {
            if (timerRef.current) clearTimeout(timerRef.current);
        };
    }, [pathname, searchParams]);

    if (!visible && progress === 0) return null;

    return (
        <>
            {/* Slim top progress bar */}
            <div className="fixed top-0 left-0 right-0 z-[9999] h-[3px] bg-transparent pointer-events-none">
                <div
                    className="h-full bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 transition-all duration-300 ease-out shadow-[0_0_10px_rgba(139,92,246,0.8)]"
                    style={{ width: `${progress}%` }}
                />
            </div>
        </>
    );
}

/**
 * Call this function from SmartCTAButton / any click handler
 * to trigger the loading bar before navigation.
 */
export function triggerPageLoad() {
    // Dispatch a custom event that GlobalLoader listens to
    window.dispatchEvent(new Event("page-load-start"));
}
