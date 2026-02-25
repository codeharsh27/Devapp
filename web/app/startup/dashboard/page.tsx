
"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { useAppSelector } from "@/lib/store/hooks";
import { StartupSidebar } from "./components/StartupSidebar";
import { STARTUP_ROLES } from "@/lib/auth/roles";
import { OverviewView } from "./components/OverviewView";
import { PastDropsView } from "./components/PastDropsView";
import { TalentView } from "./components/TalentView";
import { CandidatesView } from "./components/CandidatesView";
import { DropDetailView } from "./components/DropDetailView";
import { ProfileView } from "./components/ProfileView";
import { RealtimeChat } from "@/components/RealtimeChat";
import { useStartupTasks } from "@/lib/hooks/useStartupTasks";
import { SupportView } from "./components/SupportView";

export default function StartupDashboardPage() {
    const [currentView, setCurrentView] = useState<'overview' | 'drops' | 'candidates' | 'talent' | 'messages' | 'profile' | 'support'>('overview');
    const [selectedDropId, setSelectedDropId] = useState<string | null>(null);
    const [defaultConversationId, setDefaultConversationId] = useState<string | null>(null);

    const { user, isAuthenticated, isLoading } = useAppSelector(state => state.auth);
    // userId is needed for chat and tasks
    const userId = user?.id;
    const isAuthorized = isAuthenticated && user && STARTUP_ROLES.includes(user.role || '');

    // Data Hook (Lifted State)
    const { tasks, loading } = useStartupTasks(userId);

    const router = useRouter();

    useEffect(() => {
        if (!isLoading) {
            if (!isAuthenticated || !user) {
                router.push("/auth");
            } else if (!STARTUP_ROLES.includes(user.role || '')) {
                router.push("/talent/dashboard");
            }
        }
    }, [isLoading, isAuthenticated, user, router]);

    if (isLoading || !isAuthorized) return null; // Or Loader

    // Find Document
    const selectedDrop = tasks.find(t => t.id === selectedDropId);

    // Handlers
    const openDrop = (id: string) => {
        setSelectedDropId(id);
        // Overlay mode, no view switch needed
    };

    const openChat = async (targetUserId: string) => {
        if (!userId) {
            console.error("User ID missing");
            return;
        }


        try {
            // Dynamically import service to avoid hooks rules breaking if used here
            const { createChatService } = await import("@/lib/services/chat");
            const service = await createChatService();
            const conversationId = await service.startConversation(userId, targetUserId);

            setDefaultConversationId(conversationId);
            setCurrentView('messages');
            setSelectedDropId(null); // Close overlay
        } catch (e: any) {
            console.error("Failed to start chat:", e.message, e);
        }
    };

    return (
        <div className="flex h-screen bg-[#0c0c0e] font-sans overflow-hidden text-zinc-300 selection:bg-indigo-500/30">
            {/* Detail Overlay */}
            {selectedDropId && selectedDrop && (
                <DropDetailView drop={selectedDrop} onClose={() => setSelectedDropId(null)} onMessage={openChat} />
            )}

            <StartupSidebar
                currentView={currentView}
                setCurrentView={setCurrentView}
                onOpenCreate={() => router.push("/startup/dashboard/new-drop")}
            />

            <main className="flex-1 flex flex-col min-w-0 overflow-hidden bg-[#0c0c0e] relative">
                <div key={currentView} className="flex-1 h-full overflow-y-auto duration-300 animate-in fade-in slide-in-from-bottom-4">
                    {currentView === 'overview' && (
                        <OverviewView
                            startupId={userId}
                            setView={setCurrentView}
                            onOpenCreate={() => router.push("/startup/dashboard/new-drop")}
                            onOpenDrop={openDrop}
                        />
                    )}

                    {currentView === 'drops' && (
                        <PastDropsView />
                    )}

                    {currentView === 'talent' && (
                        <TalentView onMessage={openChat} />
                    )}

                    {currentView === 'candidates' && (
                        <CandidatesView onMessageRedirect={openChat} />
                    )}

                    {currentView === 'messages' && (
                        <RealtimeChat userId={userId} defaultConversationId={defaultConversationId} />
                    )}

                    {currentView === 'profile' && (
                        <ProfileView userId={userId} />
                    )}

                    {currentView === 'support' && (
                        <SupportView />
                    )}
                </div>
            </main>
        </div>
    );
}
