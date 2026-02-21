
"use client";
import { Monitor, Layers, Users, MessageSquare, User, LogOut, Plus, Code2 } from "lucide-react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export function StartupSidebar({ currentView, setCurrentView, onOpenCreate }: { currentView: string, setCurrentView: (view: any) => void, onOpenCreate: () => void }) {
    const router = useRouter();

    const menuItems = [
        { id: 'overview', label: 'Dashboard', icon: Monitor },
        { id: 'drops', label: 'Missions', icon: Layers },
        { id: 'talent', label: 'Talent Pool', icon: Users },
        { id: 'messages', label: 'Messages', icon: MessageSquare },
        { id: 'profile', label: 'Profile', icon: User },
    ];

    const handleLogout = async () => {
        const supabase = createClient();
        await supabase.auth.signOut();
        router.push("/auth");
    };

    return (
        <aside className="w-64 border-r border-zinc-800 bg-[#0c0c0e] flex flex-col p-4 shrink-0 h-full">
            <div className="px-4 py-8 mb-4 flex items-center gap-3">
                <div className="w-8 h-8 bg-white flex items-center justify-center">
                    <Code2 className="w-4 h-4 text-black" />
                </div>
                <span className="text-lg font-bold tracking-tight text-white uppercase">DevApp_Inc.</span>
            </div>

            <button
                onClick={onOpenCreate}
                className="mx-4 mb-8 flex items-center justify-center gap-2 bg-white text-black py-3 rounded-xl font-bold hover:bg-zinc-200 transition-colors shadow-lg shadow-indigo-900/10"
            >
                <Plus className="w-5 h-5" /> New Mission
            </button>

            <nav className="flex-1 space-y-1">
                {menuItems.map((item) => {
                    const isActive = currentView === item.id;
                    const Icon = item.icon;
                    return (
                        <button
                            key={item.id}
                            onClick={() => setCurrentView(item.id)}
                            className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all group ${isActive ? 'bg-zinc-800 text-white' : 'text-zinc-500 hover:text-white hover:bg-zinc-800/50'}`}
                        >
                            <Icon className={`w-5 h-5 ${isActive ? 'text-indigo-400' : 'group-hover:text-indigo-400 transition-colors'}`} />
                            <span className="text-sm font-medium">{item.label}</span>
                        </button>
                    )
                })}
            </nav>

            <div className="mb-4">
                <div className="bg-zinc-900/50 border border-zinc-800 rounded-xl p-4">
                    <h4 className="text-white text-sm font-bold mb-1">Shape DevApp</h4>
                    <p className="text-zinc-500 text-xs mb-3 leading-relaxed">Your feedback helps us build a better platform for founders.</p>
                    <button
                        onClick={() => window.open('https://docs.google.com/forms/d/e/1FAIpQLSf9A8IsV1tkmCJuVfjLZ_tP890Q2yabvoggQh1f8IScCUMJJw/viewform?usp=publish-editor', '_blank')}
                        className="w-full bg-white text-black text-xs font-bold py-2 rounded-lg hover:bg-zinc-200 transition-colors"
                    >
                        Share Feedback
                    </button>
                </div>
            </div>

            <button onClick={handleLogout} className="flex items-center gap-3 px-4 py-3 text-zinc-600 hover:text-white transition-colors mt-auto">
                <LogOut className="w-5 h-5" />
                <span className="text-sm font-medium">Log Out</span>
            </button>
        </aside>
    );
}
