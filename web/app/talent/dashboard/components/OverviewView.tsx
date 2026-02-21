
"use client";

import { useTalentStats } from "@/lib/hooks/useTalentStats";
import { Zap, Briefcase, DollarSign, Clock, Bell, ArrowUpRight } from "lucide-react";
import { Skeleton } from "@/components/ui/Skeleton";
import { Space_Grotesk } from "next/font/google";

const spaceGrotesk = Space_Grotesk({ subsets: ["latin"], weight: ["300", "400", "500"] });

export function TalentOverview({ setView, userId }: { setView: (v: any) => void, userId: string | undefined }) {
    const { stats, loading } = useTalentStats(userId);

    // Filter "Active" work? We'd simpler just link to submissions
    // For MVP, we use stats to render.

    return (
        <div className="space-y-10 animate-in fade-in duration-700">

            {/* Hero Section */}
            <div className="relative overflow-hidden rounded-3xl border border-zinc-800 bg-gradient-to-br from-zinc-900 via-[#0c0c0e] to-[#0c0c0e] p-8 lg:p-10">
                <div className="absolute top-0 right-0 -mt-10 -mr-10 w-64 h-64 bg-indigo-500/10 rounded-full blur-3xl"></div>
                <div className="relative z-10 flex flex-col md:flex-row justify-between items-start md:items-end gap-6">
                    <div>
                        <h2 className={`text-4xl md:text-5xl font-medium text-white mb-3 tracking-tight ${spaceGrotesk.className}`}>
                            Build. Ship. <span className="text-indigo-500">Contribute.</span>
                        </h2>
                        <p className="text-zinc-400 text-lg max-w-xl leading-relaxed">
                            Welcome back. You currently have <span className="text-white font-bold">{loading ? "..." : stats.enrollments} active missions</span>.
                        </p>
                    </div>
                    <button
                        onClick={() => setView('explore')}
                        className="group flex items-center gap-2 bg-white text-black px-6 py-3 rounded-full font-bold hover:bg-zinc-200 transition-all shadow-lg shadow-indigo-500/10"
                    >
                        Find Missions
                        <ArrowUpRight className="w-4 h-4 group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform" />
                    </button>
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">

                {/* Left Column: Stats & Active Work */}
                <div className="lg:col-span-2 space-y-8">

                    {/* Stats Grid */}
                    <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                        <div className="p-5 rounded-2xl bg-[#111113] border border-zinc-800/50 hover:border-zinc-700 transition-colors group">
                            <div className="w-8 h-8 rounded-lg bg-zinc-800/50 flex items-center justify-center mb-3">
                                <Briefcase className="w-4 h-4 text-zinc-400 group-hover:text-white transition-colors" />
                            </div>
                            <div className="text-zinc-500 text-xs font-semibold uppercase tracking-wider mb-1">Completed</div>
                            <div className="text-2xl font-mono text-white">{loading ? <Skeleton className="h-8 w-12" /> : stats.completed}</div>
                        </div>
                        <div className="p-5 rounded-2xl bg-[#111113] border border-zinc-800/50 hover:border-zinc-700 transition-colors group">
                            <div className="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center mb-3">
                                <Zap className="w-4 h-4 text-emerald-400" />
                            </div>
                            <div className="text-zinc-500 text-xs font-semibold uppercase tracking-wider mb-1">Avg Score</div>
                            <div className="text-2xl font-mono text-white">{loading ? <Skeleton className="h-8 w-12" /> : stats.avgScore}</div>
                        </div>
                        <div className="p-5 rounded-2xl bg-[#111113] border border-zinc-800/50 hover:border-zinc-700 transition-colors group">
                            <div className="w-8 h-8 rounded-lg bg-amber-500/10 flex items-center justify-center mb-3">
                                <Clock className="w-4 h-4 text-amber-400" />
                            </div>
                            <div className="text-zinc-500 text-xs font-semibold uppercase tracking-wider mb-1">Active</div>
                            <div className="text-2xl font-mono text-white">{loading ? <Skeleton className="h-8 w-12" /> : stats.enrollments}</div>
                        </div>
                    </div>

                    {/* Recent Activity */}
                    <div>
                        <div className="flex items-center justify-between px-1 mb-4">
                            <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest flex items-center gap-2">
                                <Clock className="w-4 h-4" /> Recent Activity
                            </h3>
                            <button onClick={() => setView('submissions')} className="text-xs text-zinc-500 hover:text-white transition-colors">View All</button>
                        </div>

                        <div className="space-y-3">
                            {/* Active Submissions Stream */}
                            {/* @ts-ignore */}
                            {stats.activeSubmissions && stats.activeSubmissions.length > 0 ? (
                                // @ts-ignore
                                stats.activeSubmissions.map((sub: any) => (
                                    <div
                                        key={sub.id}
                                        onClick={() => setView('submissions')}
                                        className="bg-[#111113] border border-zinc-800 rounded-xl p-4 flex items-center justify-between hover:bg-zinc-800/50 cursor-pointer group transition-colors"
                                    >
                                        <div className="flex items-center gap-4">
                                            <div className={`w-1 h-8 rounded-full ${sub.status === 'enrolled' ? 'bg-amber-500' : 'bg-indigo-500'}`}></div>
                                            <div>
                                                <h4 className="text-sm font-bold text-zinc-200 group-hover:text-white">{sub.task.title}</h4>
                                                <p className="text-xs text-zinc-500 capitalize">{sub.status} • {sub.task.category}</p>
                                            </div>
                                        </div>
                                        <ArrowUpRight className="w-4 h-4 text-zinc-600 group-hover:text-white" />
                                    </div>
                                ))
                            ) : (
                                <div className="text-center py-8 text-zinc-600 border border-dashed border-zinc-900 rounded-xl text-xs">
                                    No active work. Find a mission!
                                </div>
                            )}
                        </div>
                    </div>
                </div>

                {/* Right Column: CTA */}
                <div className="space-y-6">
                    <div className="p-6 rounded-2xl border border-dashed border-zinc-800 flex flex-col items-center justify-center text-center h-full min-h-[200px]">
                        <div className="w-12 h-12 bg-zinc-900 rounded-full flex items-center justify-center mb-4 text-zinc-500">
                            <ArrowUpRight />
                        </div>
                        <h3 className="text-white font-bold mb-2">Ready for more?</h3>
                        <p className="text-zinc-500 text-sm mb-6">Explore new drops and build your reputation.</p>
                        <button onClick={() => setView('explore')} className="text-indigo-400 hover:text-indigo-300 text-sm font-bold uppercase tracking-wide">Browse Drops</button>
                    </div>
                </div>

            </div>
        </div>
    );
}
