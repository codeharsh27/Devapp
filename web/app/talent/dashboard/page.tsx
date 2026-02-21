
"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
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

export default function TalentDashboardPage() {
    // Navigation State
    const [currentView, setCurrentView] = useState<'overview' | 'explore' | 'submissions' | 'messages' | 'profile'>('overview');
    const [userId, setUserId] = useState<string | undefined>(undefined);
    const router = useRouter();

    useEffect(() => {
        const checkUser = async () => {
            const supabase = createClient();
            const { data: { user } } = await supabase.auth.getUser();

            if (!user) {
                router.push("/auth");
                return;
            }
            setUserId(user.id);

            // Check if user is startup
            const profile = await supabase
                .from('profiles')
                .select('*')
                .eq('id', user.id)
                .single();

            if (profile.data && isStartupRole(profile.data.role)) {
                router.push("/dashboard/startup");
            }
        };

        checkUser();
    }, [router]);

    return (
        <div className="flex h-screen bg-[#0c0c0e] font-sans overflow-hidden text-zinc-300 selection:bg-indigo-500/30">

            {/* Sidebar */}
            <TalentSidebar currentView={currentView} setCurrentView={setCurrentView} />

            {/* Main Content Area */}
            <main className="flex-1 flex flex-col min-w-0 overflow-hidden bg-[#0c0c0e] relative">

                {/* Dashboard Content */}
                <div key={currentView} className={currentView === 'messages' ? "flex-1 h-full flex flex-col animate-in fade-in duration-300" : "p-8 pb-32 max-w-7xl mx-auto h-full overflow-y-auto animate-in fade-in slide-in-from-bottom-4 duration-500"}>
                    {currentView === 'overview' && (
                        <TalentOverview setView={setCurrentView} userId={userId} />
                    )}

                    {currentView === 'explore' && (
                        <ExploreDropsView userId={userId} />
                    )}

                    {currentView === 'submissions' && (
                        <SubmissionsView userId={userId} />
                    )}

                    {currentView === 'messages' && (
                        <RealtimeChat userId={userId} />
                    )}

                    {currentView === 'profile' && (
                        <ProfileView userId={userId} />
                    )}
                </div>
            </main>
        </div>
    );
}
