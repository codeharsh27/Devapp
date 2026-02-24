
"use client";
import { useState } from "react";
import { Monitor, Briefcase, MessageSquare, User, LogOut, Code2, Globe2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useAppSelector } from "@/lib/store/hooks";

export function TalentSidebar({ currentView, setCurrentView }: { currentView: string, setCurrentView: (view: any) => void }) {
    const router = useRouter();
    const globalUnreadCount = useAppSelector(state => state.chat.globalUnreadCount);

    const menuItems = [
        { id: 'overview', label: 'Dashboard', icon: Monitor },
        { id: 'explore', label: 'Explore Drops', icon: Globe2 },
        { id: 'submissions', label: 'My Submissions', icon: Briefcase },
        { id: 'messages', label: 'Inbox', icon: MessageSquare },
        { id: 'profile', label: 'Profile', icon: User },
    ];

    const handleLogout = async () => {
        const supabase = createClient();
        await supabase.auth.signOut();
        router.push("/auth");
    };

    return (
        <aside className="w-64 border-r border-zinc-800 bg-[#0c0c0e] flex flex-col p-4 shrink-0">
            <div className="px-4 py-8 mb-4 flex items-center gap-3">
                <div className="w-8 h-8 bg-white flex items-center justify-center">
                    <Code2 className="w-4 h-4 text-black" />
                </div>
                <span className="text-lg font-bold tracking-tight text-white uppercase">DevApp_Inc.</span>
            </div>

            <nav className="flex-1 space-y-1">
                {menuItems.map((item) => {
                    const isActive = currentView === item.id;
                    const Icon = item.icon;
                    return (
                        <button
                            key={item.id}
                            onClick={() => setCurrentView(item.id)}
                            className={`w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all group ${isActive ? 'bg-zinc-800 text-white' : 'text-zinc-500 hover:text-white hover:bg-zinc-800/50'}`}
                        >
                            <div className="flex items-center gap-3">
                                <Icon className={`w-5 h-5 ${isActive ? 'text-indigo-400' : 'group-hover:text-indigo-400 transition-colors'}`} />
                                <span className="text-sm font-medium">{item.label}</span>
                            </div>
                            {item.id === 'messages' && globalUnreadCount > 0 && (
                                <span className="bg-indigo-600 text-white text-[10px] font-bold px-2 py-0.5 rounded-full">
                                    {globalUnreadCount}
                                </span>
                            )}
                        </button>
                    )
                })}
            </nav>

            <div className="mb-4">
                <div className="bg-zinc-900/50 border border-zinc-800 rounded-xl p-4">
                    <h4 className="text-white text-sm font-bold mb-1">Help us improve</h4>
                    <p className="text-zinc-500 text-xs mb-3 leading-relaxed">Spot a bug or have a feature idea? We'd love your input.</p>
                    <button
                        onClick={() => window.open('https://docs.google.com/forms/d/e/1FAIpQLSdifeIRJsUDwgW_zMbEby_yPrmcgxl08u_mRBKUatFdJhdy4Q/viewform?usp=publish-editor', '_blank')}
                        className="w-full bg-white text-black text-xs font-bold py-2 rounded-lg hover:bg-zinc-200 transition-colors"
                    >
                        Give Feedback
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
