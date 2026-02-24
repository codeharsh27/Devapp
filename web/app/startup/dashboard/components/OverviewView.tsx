
"use client";
import { ArrowUpRight, Plus, Zap, AlertCircle, Loader2 } from "lucide-react";
import { useStartupTasks } from "@/lib/hooks/useStartupTasks";

export function OverviewView({ setView, onOpenCreate, onOpenDrop, startupId }: { setView: (view: any) => void, onOpenCreate: () => void, onOpenDrop: (id: string) => void, startupId?: string }) {

    const { tasks, loading } = useStartupTasks(startupId);

    const activeStream = tasks.filter(t => t.status !== 'closed' && t.status !== 'completed').slice(0, 5);
    const totalSubmissions = tasks.reduce((acc, curr) => acc + (curr.submissions || 0), 0);
    const pendingReviews = tasks.filter(t => t.status === 'review').length;
    const totalSpend = tasks.filter(t => t.status === 'completed' || t.status === 'closed').reduce((acc, curr) => acc + (Number(curr.bounty_amount) || 0), 0);

    if (loading) return <div className="flex h-full items-center justify-center"><Loader2 className="animate-spin text-zinc-500" /></div>;

    return (
        <div className="max-w-7xl mx-auto p-8 pt-12 space-y-12 animate-in fade-in duration-500 pb-24">

            {/* Header */}
            <div className="flex items-center justify-between pb-6 border-b border-zinc-800/50">
                <div>
                    <h1 className="text-3xl font-light text-white tracking-tight mb-2">
                        Dashboard
                    </h1>
                    <p className="text-zinc-500 text-sm">Welcome back. You have <span className="text-white font-bold">{pendingReviews} pending reviews</span>.</p>
                </div>
                <button
                    onClick={onOpenCreate}
                    className="flex items-center gap-2 px-6 py-2.5 bg-white text-black rounded-full font-bold text-sm hover:bg-zinc-200 transition-all shadow-[0_0_20px_rgba(255,255,255,0.1)] group"
                >
                    <Plus className="w-4 h-4 transition-transform group-hover:rotate-90" /> Post New Project
                </button>
            </div>

            {/* Stats Metrics */}
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
                <div className="p-6 rounded-2xl bg-[#111113] border border-zinc-800 hover:border-indigo-500/30 transition-colors">
                    <div className="text-zinc-500 text-xs font-bold uppercase tracking-wider mb-2">Total Applications</div>
                    <div className="text-4xl font-mono text-white">{totalSubmissions}</div>
                </div>
                <div className="p-6 rounded-2xl bg-[#111113] border border-zinc-800 hover:border-emerald-500/30 transition-colors">
                    <div className="text-zinc-500 text-xs font-bold uppercase tracking-wider mb-2">Total Spent</div>
                    <div className="text-4xl font-mono text-emerald-400">${totalSpend.toFixed(2)}</div>
                </div>
                <div className="p-6 rounded-2xl bg-[#111113] border border-zinc-800 hover:border-amber-500/30 transition-colors">
                    <div className="text-zinc-500 text-xs font-bold uppercase tracking-wider mb-2">Active Projects</div>
                    <div className="text-4xl font-mono text-white">{activeStream.length}</div>
                </div>
                <div className="p-6 rounded-2xl bg-[#111113] border border-zinc-800 hover:border-blue-500/30 transition-colors">
                    <div className="text-zinc-500 text-xs font-bold uppercase tracking-wider mb-2">Avg. Complexity</div>
                    <div className="text-4xl font-mono text-white">
                        {tasks.length > 0
                            ? (tasks.reduce((acc, curr) => acc + (curr.difficulty_level || 0), 0) / tasks.length).toFixed(1)
                            : "0.0"}
                    </div>
                </div>
            </div>

            {/* Active Operations */}
            <section className="space-y-4">
                <div className="flex items-center justify-between px-1">
                    <h2 className="text-xs font-bold text-zinc-500 uppercase tracking-widest flex items-center gap-2">
                        <Zap className="w-4 h-4" /> Recent Activity
                    </h2>
                    <button onClick={() => setView('drops')} className="text-xs text-zinc-500 hover:text-white transition-colors">View All</button>
                </div>

                {activeStream.length === 0 ? (
                    <div className="text-center py-12 border border-dashed border-zinc-800 rounded-xl relative overflow-hidden group">
                        <div className="absolute inset-0 bg-indigo-500/5 opacity-0 group-hover:opacity-100 transition-opacity"></div>
                        <p className="text-zinc-500 text-sm mb-4 relative z-10">No active projects.</p>
                        <button onClick={onOpenCreate} className="relative z-10 text-indigo-400 hover:text-indigo-300 text-xs font-bold uppercase">Post a project</button>
                    </div>
                ) : (
                    <div className="space-y-3">
                        {activeStream.map((drop) => (
                            <div
                                key={drop.id}
                                onClick={() => onOpenDrop(drop.id)}
                                className="bg-[#0c0c0e] border border-zinc-800 rounded-xl p-5 flex items-center justify-between hover:border-zinc-600 hover:bg-zinc-900/30 transition-all cursor-pointer group"
                            >
                                <div className="flex items-center gap-4">
                                    <div className={`w-2 h-12 rounded-full ${drop.status === 'open' ? 'bg-emerald-500' : 'bg-amber-500'}`}></div>
                                    <div>
                                        <h3 className="text-md font-bold text-zinc-200 group-hover:text-white transition-colors">{drop.title}</h3>
                                        <div className="flex items-center gap-3 mt-1">
                                            <span className="text-[10px] font-bold uppercase tracking-wider text-zinc-500 border border-zinc-800 px-2 py-0.5 rounded bg-zinc-900">{drop.category}</span>
                                        </div>
                                    </div>
                                </div>

                                <div className="flex items-center gap-6">
                                    <div className="text-right">
                                        <div className="text-2xl font-light text-zinc-400 group-hover:text-white transition-colors">{drop.submissions}</div>
                                        <div className="text-[10px] text-zinc-600 uppercase tracking-widest">Applications</div>
                                    </div>
                                    <ArrowUpRight className="w-5 h-5 text-zinc-700 group-hover:text-white transition-colors" />
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </section>
        </div>
    );
}
