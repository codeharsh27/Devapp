
"use client";

import { useState } from "react";
import { ArrowUpRight, Loader2, Calendar, AlertCircle } from "lucide-react";
import { PageLoader } from "@/components/ui/PageLoader";

export function DropsView({ tasks, loading, onOpenDrop }: { tasks: any[], loading: boolean, onOpenDrop: (id: string) => void }) {
    const [filter, setFilter] = useState('all');

    const filteredTasks = tasks.filter(t => {
        if (filter === 'all') return true;
        if (filter === 'active') return t.status === 'open' || t.status === 'reviewing';
        if (filter === 'closed') return t.status === 'closed';
        return true;
    });

    if (loading) return <PageLoader />;

    return (
        <div className="max-w-7xl mx-auto p-8 animate-in fade-in duration-500">
            <div className="flex items-center justify-between mb-8">
                <h1 className="text-3xl font-light text-white">Missions</h1>

                <div className="flex items-center bg-[#111113] border border-zinc-800 rounded-lg p-1">
                    {['all', 'active', 'closed'].map(f => (
                        <button
                            key={f}
                            onClick={() => setFilter(f)}
                            className={`px-4 py-1.5 rounded-md text-xs font-bold uppercase tracking-wide transition-all ${filter === f ? 'bg-zinc-800 text-white shadow-sm' : 'text-zinc-500 hover:text-zinc-300'}`}
                        >
                            {f}
                        </button>
                    ))}
                </div>
            </div>

            <div className="space-y-4">
                {filteredTasks.map(task => (
                    <div
                        key={task.id}
                        onClick={() => onOpenDrop(task.id)}
                        className="group bg-[#111113] border border-zinc-800 rounded-xl p-6 hover:border-zinc-700 hover:bg-zinc-800/30 transition-all cursor-pointer relative overflow-hidden"
                    >
                        <div className="flex justify-between items-start">
                            <div className="flex items-start gap-4">
                                <div className={`w-1.5 h-12 rounded-full mt-1 ${task.status === 'open' ? 'bg-emerald-500' : 'bg-zinc-700'}`}></div>
                                <div>
                                    <h3 className="text-lg font-bold text-zinc-200 group-hover:text-white transition-colors mb-1">{task.title}</h3>
                                    <div className="flex items-center gap-3 text-xs text-zinc-500 uppercase tracking-wide">
                                        <span>{task.category}</span>
                                        <span>•</span>
                                        <span className="flex items-center gap-1"><Calendar className="w-3 h-3" /> {new Date(task.created_at).toLocaleDateString()}</span>
                                        {task.submissions > 0 && (
                                            <span className="text-indigo-400 font-bold flex items-center gap-1">
                                                <AlertCircle className="w-3 h-3" /> {task.submissions} Applications
                                            </span>
                                        )}
                                    </div>
                                </div>
                            </div>

                            <div className="flex items-center gap-6">
                                <div className="text-right">
                                    <div className="text-2xl font-light text-zinc-400 group-hover:text-white transition-colors">{task.submissions}</div>
                                    <div className="text-[10px] text-zinc-500 uppercase tracking-widest font-bold">Applications</div>
                                </div>
                                <div className="w-10 h-10 rounded-full border border-zinc-800 flex items-center justify-center group-hover:bg-white group-hover:text-black transition-all">
                                    <ArrowUpRight className="w-5 h-5" />
                                </div>
                            </div>
                        </div>
                    </div>
                ))}

                {filteredTasks.length === 0 && (
                    <div className="text-center py-20 text-zinc-500 border border-dashed border-zinc-800 rounded-xl">
                        No missions found.
                    </div>
                )}
            </div>
        </div>
    );
}
