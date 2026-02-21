
"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { StartupSidebar } from "./components/StartupSidebar";
import { STARTUP_ROLES } from "@/lib/auth/roles";
import { OverviewView } from "./components/OverviewView";
import { DropsView } from "./components/DropsView";
import { TalentView } from "./components/TalentView";
import { DropDetailView } from "./components/DropDetailView";
import { ProfileView } from "./components/ProfileView";
import { RealtimeChat } from "@/components/RealtimeChat";
import { useStartupTasks } from "@/lib/hooks/useStartupTasks";

export default function StartupDashboardPage() {
    const [currentView, setCurrentView] = useState<'overview' | 'drops' | 'talent' | 'messages' | 'profile'>('overview');
    const [userId, setUserId] = useState<string | undefined>(undefined);
    const [selectedDropId, setSelectedDropId] = useState<string | null>(null);
    const [isAuthorized, setIsAuthorized] = useState(false);

    // New state for handling chat redirection
    const [defaultConversationId, setDefaultConversationId] = useState<string | null>(null);

    // Data Hook (Lifted State)
    const { tasks, loading } = useStartupTasks(userId);

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

            const profile = await supabase.from('profiles').select('*').eq('id', user.id).single();
            if (profile.data && STARTUP_ROLES.includes(profile.data.role)) {
                setIsAuthorized(true);
            } else {
                router.push("/dashboard/talent");
            }
        };
        checkUser();
    }, [router]);

    if (!isAuthorized) return null; // Or Loader

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

        console.log("Opening chat with:", targetUserId);

        try {
            // Dynamically import service to avoid hooks rules breaking if used here
            const { createChatService } = await import("@/lib/services/chat");
            const service = await createChatService();
            console.log("Service created, starting conversation...");
            const conversationId = await service.startConversation(userId, targetUserId);
            console.log("Conversation started:", conversationId);

            setDefaultConversationId(conversationId);
            setCurrentView('messages');
            setSelectedDropId(null); // Close overlay
        } catch (e: any) {
            console.error("Failed to start chat", e.message, e);
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
                        <DropsView
                            tasks={tasks} // Pass lifted state
                            loading={loading}
                            onOpenDrop={openDrop}
                        />
                    )}

                    {currentView === 'talent' && (
                        <TalentView onMessage={openChat} />
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
