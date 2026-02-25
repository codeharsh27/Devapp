"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { useAppSelector } from "@/lib/store/hooks";
import { isStartupRole } from "@/lib/auth/roles";
import { TalentSidebar } from "./components/TalentSidebar";
import { ExploreDropsView } from "./components/ExploreDropsView";
import { SubmissionsView } from "./components/SubmissionsView";
import { RealtimeChat } from "@/components/RealtimeChat";
import { TalentOverview } from "./components/OverviewView";
import { ProfileView } from "./components/ProfileView";
import { Space_Grotesk } from "next/font/google";

const spaceGrotesk = Space_Grotesk({
    subsets: ["latin"],
    weight: ["300", "400", "500"],
});

type View = "overview" | "explore" | "submissions" | "messages" | "profile";

import { useLiveActivity } from "@/lib/hooks/useLiveActivity";

export default function TalentDashboardPage() {
    const [currentView, setCurrentView] = useState<View>("overview");
    const { user, isAuthenticated, isLoading } = useAppSelector(state => state.auth);
    const router = useRouter();
    const userId = user?.id;
    // Derive display name: profile name > email prefix > fallback
    const userName = user?.full_name || user?.email?.split("@")[0] || "Developer";

    const isAuthorized = isAuthenticated && user && !isStartupRole(user.role || '');

    // Initialize global realtime websocket connection
    useLiveActivity();

    useEffect(() => {
        if (!isLoading) {
            if (!isAuthenticated || !user) {
                router.push("/auth");
            } else if (isStartupRole(user.role || '')) {
                router.push("/startup/dashboard");
            }
        }
    }, [isLoading, isAuthenticated, user, router]);

    if (isLoading || !isAuthorized) return null; // Or Loader

    return (
        <div className="flex h-screen bg-[#0c0c0e] font-sans overflow-hidden text-zinc-300 selection:bg-indigo-500/30">

            {/* Sidebar */}
            <TalentSidebar currentView={currentView} setCurrentView={setCurrentView} />

            {/* Main */}
            <main className="flex-1 flex flex-col min-w-0 overflow-hidden bg-[#0c0c0e] relative">
                <div
                    key={currentView}
                    className={
                        currentView === "messages"
                            ? "flex-1 h-full flex flex-col animate-in fade-in duration-300"
                            : "p-8 pb-32 max-w-7xl mx-auto h-full overflow-y-auto animate-in fade-in slide-in-from-bottom-4 duration-500"
                    }
                >
                    {currentView === "overview" && (
                        <TalentOverview setView={setCurrentView} userId={userId} userName={userName} />
                    )}
                    {currentView === "explore" && (
                        <ExploreDropsView userId={userId} setView={setCurrentView} />
                    )}
                    {currentView === "submissions" && (
                        <SubmissionsView userId={userId} />
                    )}
                    {currentView === "messages" && (
                        <RealtimeChat userId={userId} />
                    )}
                    {currentView === "profile" && (
                        <ProfileView userId={userId} />
                    )}
                </div>
            </main>
        </div>
    );
}
