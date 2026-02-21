
"use client";
import { Users, Clock, CheckCircle2, AlertCircle, ArrowUpRight, X, MessageSquare, ExternalLink, Github, Send, PlayCircle, Terminal, Search, Loader2, Award } from "lucide-react";
import { Space_Grotesk } from "next/font/google";
import { useState, useRef, useEffect } from "react";
import { useExploreDrops } from "@/lib/hooks/useExploreDrops";
import { createSubmissionsService } from "@/lib/services/submissions";
import { useRouter } from "next/navigation";
import { Skeleton } from "@/components/ui/Skeleton";
import { PageLoader } from "@/components/ui/PageLoader";

const spaceGrotesk = Space_Grotesk({ subsets: ["latin"], weight: ["300", "400", "500"] });

function MissionDrawer({ drop, onClose, userId }: { drop: any | null, onClose: () => void, userId: string | undefined }) {
    const [isForking, setIsForking] = useState(false);
    const router = useRouter();

    const handleStart = async () => {
        if (!userId || !drop) return;
        setIsForking(true);
        try {
            const service = await createSubmissionsService();
            await service.enroll(userId, drop.id);
            // Redirect to My Submissions (or just close and show toast)
            // For now, simple alert success but ideally navigate
            // router.push("/talent/dashboard/submissions"); or setView
            // But we are in a sub-component.
            onClose();
            alert("Mission Started! Check 'My Submissions'.");
        } catch (e: any) {
            console.error(e);
            alert("Failed to start mission: " + e.message);
        } finally {
            setIsForking(false);
        }
    };

    if (!drop) return null;

    return (
        <div className="fixed inset-0 z-50 flex justify-end bg-black/50 backdrop-blur-sm animate-in fade-in duration-200">
            <div className="w-full max-w-xl h-full bg-[#0c0c0e] border-l border-zinc-800 shadow-2xl overflow-y-auto animate-in slide-in-from-right duration-300 p-8 flex flex-col">
                <div className="flex items-start justify-between mb-8 shrink-0">
                    <div>
                        <div className="flex items-center gap-3 mb-2">
                            <span className="bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 px-2 py-0.5 rounded text-[10px] font-bold uppercase">Open</span>
                            <span className="text-zinc-500 text-xs font-mono uppercase tracking-wider">Contribution</span>
                        </div>
                        <h2 className={`text-2xl font-light text-zinc-100 ${spaceGrotesk.className}`}>{drop.title}</h2>
                    </div>
                    <button onClick={onClose} className="p-2 hover:bg-zinc-800 rounded-full text-zinc-500 hover:text-white transition-colors">
                        <X className="w-5 h-5" />
                    </button>
                </div>

                <div className="space-y-8 flex-1 overflow-y-auto">
                    <div>
                        <h4 className="text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Description</h4>
                        <div className="text-zinc-300 text-sm leading-relaxed whitespace-pre-wrap">{drop.description}</div>
                    </div>

                    <div className="grid grid-cols-2 gap-4">
                        <div className="bg-zinc-900/50 p-4 rounded-xl border border-zinc-800/50">
                            <span className="text-xs font-bold text-zinc-500 uppercase tracking-wider block mb-3">Startup</span>
                            <div className="flex items-center gap-3">
                                <div className="w-8 h-8 rounded-full bg-indigo-600 flex items-center justify-center text-xs font-bold text-white uppercase">
                                    {drop.startup?.full_name?.substring(0, 2) || 'FO'}
                                </div>
                                <span className="text-sm text-zinc-300">{drop.startup?.full_name || 'Founder'}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div className="pt-6 border-t border-zinc-800 mt-auto bg-[#0c0c0e] space-y-3 shrink-0">
                    <button
                        onClick={handleStart}
                        disabled={isForking}
                        className="w-full flex items-center justify-center gap-2 p-4 rounded-xl bg-white hover:bg-zinc-200 text-black transition-all shadow-lg text-sm font-bold disabled:opacity-50 disabled:cursor-not-allowed group"
                    >
                        {isForking ? <Loader2 className="w-4 h-4 animate-spin" /> : <PlayCircle className="w-4 h-4" />}
                        Start Mission
                    </button>
                </div>
            </div>
        </div>
    );
}

export function ExploreDropsView({ userId }: { userId: string | undefined }) {
    const [searchQuery, setSearchQuery] = useState('');
    const [selectedDrop, setSelectedDrop] = useState<any | null>(null);
    const { drops, loading } = useExploreDrops();

    const filteredDrops = drops.filter(drop =>
        drop.title.toLowerCase().includes(searchQuery.toLowerCase())
    );

    const sortedDrops = filteredDrops.sort((a, b) => {
        // Prioritize promoted drops
        if (a.is_promoted && !b.is_promoted) return -1;
        if (!a.is_promoted && b.is_promoted) return 1;
        return 0;
    });

    if (loading) return <PageLoader />;

    return (
        <div className="max-w-7xl mx-auto p-8 pb-32 min-h-screen text-white font-sans animate-in fade-in duration-500">
            <MissionDrawer drop={selectedDrop} onClose={() => setSelectedDrop(null)} userId={userId} />

            {/* Header Area */}
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-10">
                <div>
                    <h1 className={`text-3xl font-light text-white mb-2 ${spaceGrotesk.className}`}>Explore Missions</h1>
                    <p className="text-zinc-500 text-sm">Find your next high-impact contribution.</p>
                </div>

                {/* Search */}
                <div className="relative group w-full md:w-96">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <Search className="h-4 w-4 text-zinc-600 group-focus-within:text-indigo-500 transition-colors" />
                    </div>
                    <input
                        type="text"
                        className="block w-full pl-10 pr-3 py-2.5 bg-[#0c0c0e] border border-zinc-800 rounded-xl leading-5 text-zinc-300 placeholder-zinc-600 focus:outline-none focus:bg-zinc-900/50 focus:border-indigo-500/50 focus:ring-1 focus:ring-indigo-500/20 sm:text-sm transition-all font-mono"
                        placeholder="Search..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                    />
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {sortedDrops.map((drop) => {
                    const isPromoted = drop.is_promoted;
                    return (
                        <div
                            key={drop.id}
                            onClick={() => setSelectedDrop(drop)}
                            className={`group relative p-6 rounded-2xl bg-[#111113] border transition-all cursor-pointer overflow-hidden ${isPromoted ? 'border-amber-500/30 hover:border-amber-500/60 shadow-[0_0_30px_-5px_var(--tw-shadow-color)] shadow-amber-500/10' : 'border-zinc-800/60 hover:border-zinc-600/60'}`}
                        >
                            {isPromoted && (
                                <div className="absolute top-0 right-0 bg-amber-500/10 text-amber-500 text-[10px] uppercase font-bold px-3 py-1 rounded-bl-xl border-l border-b border-amber-500/20 flex items-center gap-1">
                                    <Award className="w-3 h-3" /> Featured
                                </div>
                            )}

                            <div className="flex justify-between items-start gap-4">
                                <div>
                                    <h3 className="text-lg font-medium text-zinc-200 group-hover:text-white transition-colors flex items-center gap-2">
                                        {drop.title}
                                        {isPromoted && <Award className="w-4 h-4 text-amber-500" />}
                                    </h3>
                                    <div className="flex items-center gap-2 text-xs text-zinc-500 mt-1 mb-3">
                                        <span>{drop.startup?.full_name}</span>
                                        <span>•</span>
                                        <span className="capitalize">{drop.category}</span>
                                        <span>•</span>
                                        <span className={`text-zinc-400 ${isPromoted ? 'text-amber-500/80' : ''}`}>Level {drop.difficulty_level || 1}</span>
                                    </div>
                                    <p className="text-sm text-zinc-500 line-clamp-2">{drop.description}</p>
                                </div>
                                <div className={`shrink-0 w-10 h-10 rounded-full border flex items-center justify-center group-hover:bg-white group-hover:text-black transition-colors ${isPromoted ? 'border-amber-500/30 text-amber-500' : 'border-zinc-800 text-zinc-500'}`}>
                                    <ArrowUpRight className="w-5 h-5" />
                                </div>
                            </div>
                        </div>
                    );
                })}

                {filteredDrops.length === 0 && (
                    <div className="col-span-2 text-center py-20 text-zinc-500">No missions found.</div>
                )}
            </div>

        </div>
    );
}
