"use client";

import { useTalentStats } from "@/lib/hooks/useTalentStats";
import { Zap, Briefcase, Clock, ArrowUpRight, Terminal, Sparkles, Rocket, TrendingUp, Users } from "lucide-react";
import { Skeleton } from "@/components/ui/Skeleton";
import { Space_Grotesk } from "next/font/google";

const spaceGrotesk = Space_Grotesk({ subsets: ["latin"], weight: ["300", "400", "500"] });

const MOTIVATIONAL_MESSAGES = [
    { text: "Every code contribution brings a startup closer to their dream.", icon: Rocket },
    { text: "Your skills can help founders turn ideas into reality.", icon: TrendingUp },
    { text: "Build real-world experience while supporting innovation.", icon: Users },
    { text: "Startups need developers like you. Start contributing today!", icon: Sparkles },
    { text: "Your code makes an impact. See your work live in production.", icon: Zap },
];

function getMotivationalMessage(): { text: string; icon: React.ElementType } {
    const hour = new Date().getHours();
    const index = (hour + Math.floor(Math.random() * 5)) % MOTIVATIONAL_MESSAGES.length;
    return MOTIVATIONAL_MESSAGES[index];
}

type View = "overview" | "explore" | "submissions" | "messages" | "profile";

function StatCard({
    icon: Icon,
    label,
    value,
    loading,
    accent = "zinc",
}: {
    icon: React.ElementType;
    label: string;
    value: number | string;
    loading: boolean;
    accent?: "zinc" | "emerald" | "amber" | "indigo";
}) {
    const accentMap = {
        zinc: "bg-zinc-800/50 text-zinc-400",
        emerald: "bg-emerald-500/10 text-emerald-400",
        amber: "bg-amber-500/10 text-amber-400",
        indigo: "bg-indigo-500/10 text-indigo-400",
    };

    return (
        <div className="p-5 rounded-2xl bg-[#111113] border border-zinc-800/50 hover:border-zinc-700 transition-colors group cursor-default">
            <div className={`w-8 h-8 rounded-lg ${accentMap[accent]} flex items-center justify-center mb-3`}>
                <Icon className="w-4 h-4" />
            </div>
            <div className="text-zinc-500 text-xs font-semibold uppercase tracking-wider mb-1">{label}</div>
            <div className="text-2xl font-mono text-white">
                {loading ? <Skeleton className="h-8 w-12" /> : value}
            </div>
        </div>
    );
}

export function TalentOverview({
    setView,
    userId,
    userName,
}: {
    setView: (v: View) => void;
    userId: string | undefined;
    userName?: string;
}) {
    const { stats, loading } = useTalentStats(userId);

    // Derive first name for greeting
    const firstName = userName?.split(" ")[0] ?? "Developer";

    // Time-based greeting
    const hour = new Date().getHours();
    const greeting =
        hour < 12 ? "Good morning" :
            hour < 17 ? "Good afternoon" :
                "Good evening";

    const motivational = getMotivationalMessage();

    return (
        <div className="space-y-10 animate-in fade-in duration-700">

            {/* ── Hero Banner ── */}
            <div className="relative overflow-hidden rounded-3xl border border-zinc-800 bg-gradient-to-br from-zinc-900 via-[#0c0c0e] to-[#0c0c0e] p-8 lg:p-10">
                {/* Decorative glow */}
                <div className="absolute top-0 right-0 -mt-16 -mr-16 w-72 h-72 bg-indigo-500/10 rounded-full blur-3xl pointer-events-none" />
                <div className="absolute bottom-0 left-0 -mb-10 -ml-10 w-48 h-48 bg-purple-500/5 rounded-full blur-2xl pointer-events-none" />

                <div className="relative z-10 flex flex-col md:flex-row justify-between items-start md:items-end gap-6">
                    <div>
                        <div className="flex items-center gap-2 mb-3">
                            <span className="flex h-2 w-2 rounded-full bg-emerald-400 animate-pulse" />
                            <span className="text-emerald-400 text-xs font-bold uppercase tracking-widest">Dashboard</span>
                        </div>
                        <h2 className={`text-4xl md:text-5xl font-medium text-white tracking-tight ${spaceGrotesk.className}`}>
                            {greeting},{" "}
                            <span className="text-indigo-400">{firstName}.</span>
                        </h2>
                        <p className="text-zinc-400 text-base mt-3 max-w-lg leading-relaxed">
                            {loading ? (
                                <Skeleton className="h-5 w-64" />
                            ) : stats.enrollments > 0 ? (
                                <>
                                    You have{" "}
                                    <span className="text-white font-bold">{stats.enrollments} active {stats.enrollments === 1 ? "mission" : "missions"}</span>{" "}
                                    in progress. Keep shipping.
                                </>
                            ) : (
                                <>
                                    You have no active missions yet.{" "}
                                    <button
                                        onClick={() => setView("explore")}
                                        className="text-indigo-400 hover:text-indigo-300 font-semibold underline underline-offset-2 transition-colors"
                                    >
                                        Explore open drops →
                                    </button>
                                </>
                            )}
                        </p>
                    </div>

                    <button
                        onClick={() => setView("explore")}
                        className="group flex items-center gap-2 bg-white text-black px-6 py-3 rounded-full font-bold hover:bg-zinc-200 transition-all shadow-lg shadow-indigo-500/10 whitespace-nowrap shrink-0"
                    >
                        Find Missions
                        <ArrowUpRight className="w-4 h-4 group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform" />
                    </button>
                </div>
            </div>

            {/* ── Motivational Banner ── */}
            <div className="relative overflow-hidden rounded-2xl border border-indigo-500/20 bg-gradient-to-r from-indigo-500/5 via-purple-500/5 to-indigo-500/5 p-5">
                <div className="absolute top-0 right-0 -mt-8 -mr-8 w-32 h-32 bg-indigo-500/10 rounded-full blur-2xl pointer-events-none" />
                <div className="relative z-10 flex items-center gap-4">
                    <div className="w-10 h-10 rounded-xl bg-indigo-500/20 flex items-center justify-center shrink-0">
                        <motivational.icon className="w-5 h-5 text-indigo-400" />
                    </div>
                    <div>
                        <p className="text-indigo-300 text-sm font-medium">
                            {motivational.text}
                        </p>
                        <p className="text-zinc-500 text-xs mt-1">
                            Join developers building the next generation of startups.
                        </p>
                    </div>
                </div>
            </div>

            {/* ── Stats + Activity ── */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">

                {/* Left: Stats + Activity stream */}
                <div className="lg:col-span-2 space-y-8">

                    {/* Stats Grid */}
                    <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                        <StatCard icon={Briefcase} label="Completed" value={stats.completed} loading={loading} accent="zinc" />
                        <StatCard icon={Zap} label="Avg Score" value={stats.avgScore === 0 ? "—" : stats.avgScore} loading={loading} accent="emerald" />
                        <StatCard icon={Clock} label="Active" value={stats.enrollments} loading={loading} accent="amber" />
                    </div>

                    {/* Active Work Stream */}
                    <div>
                        <div className="flex items-center justify-between px-1 mb-4">
                            <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest flex items-center gap-2">
                                <Terminal className="w-4 h-4" />
                                Active Work
                            </h3>
                            <button
                                onClick={() => setView("submissions")}
                                className="text-xs text-zinc-500 hover:text-white transition-colors"
                            >
                                View All →
                            </button>
                        </div>

                        <div className="space-y-3">
                            {loading ? (
                                Array.from({ length: 2 }).map((_, i) => (
                                    <Skeleton key={i} className="h-16 w-full rounded-xl" />
                                ))
                            ) : stats.activeSubmissions && stats.activeSubmissions.length > 0 ? (
                                stats.activeSubmissions.map((sub: any) => (
                                    <div
                                        key={sub.id}
                                        onClick={() => setView("submissions")}
                                        className="bg-[#111113] border border-zinc-800 rounded-xl p-4 flex items-center justify-between hover:bg-zinc-800/50 cursor-pointer group transition-colors"
                                    >
                                        <div className="flex items-center gap-4">
                                            <div className={`w-1 h-10 rounded-full shrink-0 ${sub.status === "enrolled"
                                                    ? "bg-amber-500"
                                                    : sub.status === "pending"
                                                        ? "bg-indigo-500"
                                                        : "bg-emerald-500"
                                                }`} />
                                            <div>
                                                <h4 className="text-sm font-bold text-zinc-200 group-hover:text-white">{sub.task.title}</h4>
                                                <p className="text-xs text-zinc-500 capitalize mt-0.5">
                                                    {sub.status === "enrolled"
                                                        ? "Enrolled — waiting for your submission"
                                                        : sub.status === "pending"
                                                            ? "Submitted — awaiting evaluation"
                                                            : sub.status}
                                                    {sub.task.category ? ` • ${sub.task.category}` : ""}
                                                </p>
                                            </div>
                                        </div>
                                        <ArrowUpRight className="w-4 h-4 text-zinc-600 group-hover:text-white shrink-0" />
                                    </div>
                                ))
                            ) : (
                                <div className="text-center py-10 text-zinc-600 border border-dashed border-zinc-900 rounded-xl">
                                    <Terminal className="w-6 h-6 mx-auto mb-3 opacity-30" />
                                    <p className="text-xs uppercase tracking-widest">No active missions</p>
                                    <button
                                        onClick={() => setView("explore")}
                                        className="mt-3 text-indigo-400 hover:text-indigo-300 text-xs font-bold uppercase tracking-wide transition-colors"
                                    >
                                        Browse Drops →
                                    </button>
                                </div>
                            )}
                        </div>
                    </div>
                </div>

                {/* Right: Quick actions */}
                <div className="space-y-4">

                    {/* Explore CTA card */}
                    <div className="p-6 rounded-2xl border border-dashed border-zinc-800 bg-[#111113] hover:border-zinc-700 transition-colors">
                        <div className="w-10 h-10 bg-indigo-500/10 rounded-xl flex items-center justify-center mb-4">
                            <Sparkles className="w-5 h-5 text-indigo-400" />
                        </div>
                        <h3 className="text-white font-bold mb-2">Ready for more?</h3>
                        <p className="text-zinc-500 text-sm mb-5 leading-relaxed">
                            Explore new drops and build your on-chain reputation.
                        </p>
                        <button
                            onClick={() => setView("explore")}
                            className="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-sm transition-colors flex items-center justify-center gap-2 group"
                        >
                            Browse Drops
                            <ArrowUpRight className="w-4 h-4 group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform" />
                        </button>
                    </div>

                    {/* My Submissions shortcut */}
                    <button
                        onClick={() => setView("submissions")}
                        className="w-full p-5 rounded-2xl border border-zinc-800/50 bg-[#111113] hover:border-zinc-700 transition-colors text-left group"
                    >
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-xs text-zinc-500 uppercase tracking-widest font-bold mb-1">My Work</p>
                                <p className="text-white font-semibold text-sm">
                                    {loading ? <Skeleton className="h-4 w-20 inline-block" /> : `${stats.enrollments + stats.completed} total submissions`}
                                </p>
                            </div>
                            <ArrowUpRight className="w-4 h-4 text-zinc-600 group-hover:text-white transition-colors" />
                        </div>
                    </button>
                </div>
            </div>
        </div>
    );
}
