
"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { PageLoader } from "@/components/ui/PageLoader";
import { Search, Github, Globe, Mail } from "lucide-react";
import { ArrowLeft, MessageSquare, ExternalLink, Award, Code2, Zap, Layout, ShieldCheck, Lock } from "lucide-react";

export function TalentView({ onMessage }: { onMessage: (uid: string) => void }) {
    const [talents, setTalents] = useState<any[]>([]);
    const [filteredTalents, setFilteredTalents] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedTalent, setSelectedTalent] = useState<any | null>(null);
    const [searchTerm, setSearchTerm] = useState("");

    useEffect(() => {
        const fetchTalents = async () => {
            const supabase = createClient();

            // 1. Fetch Profiles with Portfolio
            const { data, error } = await supabase
                .from('profiles')
                .select(`
                    *,
                    portfolio_items(*)
                `)
                .not('role', 'in', '("Founder","Co-Founder")')
                .limit(50);

            if (data) {
                setTalents(data);
                setFilteredTalents(data);
            }
            if (error) console.error("Error fetching talent:", error);

            setLoading(false);
        };
        fetchTalents();
    }, []);

    // Search Logic
    useEffect(() => {
        if (!searchTerm) {
            setFilteredTalents(talents);
        } else {
            const lower = searchTerm.toLowerCase();
            const filtered = talents.filter(t =>
                t.full_name?.toLowerCase().includes(lower) ||
                t.skills?.some((s: string) => s.toLowerCase().includes(lower)) ||
                t.bio?.toLowerCase().includes(lower)
            );
            setFilteredTalents(filtered);
        }
    }, [searchTerm, talents]);

    if (loading) return <PageLoader />;

    // Detail View Overlay
    if (selectedTalent) {
        // Use real profile data, fallback only for stats if not present
        const profile = selectedTalent;
        const portfolio = profile.portfolio_items || [];

        // rudimentary stats calc
        const stats = {
            dropsCompleted: portfolio.length, // approximation
            codeQualityScore: profile.reputation_score || 0, // use reputation
            totalBountyEarned: portfolio.reduce((acc: number, curr: any) => acc + (curr.bounty_amount || 0), 0)
        };

        return (
            <div className="max-w-5xl mx-auto p-8 animate-in fade-in slide-in-from-right-8 duration-300 pb-24 text-zinc-300">
                {/* Nav */}
                <button onClick={() => setSelectedTalent(null)} className="flex items-center gap-2 text-zinc-500 hover:text-white mb-8 transition-colors group">
                    <ArrowLeft className="w-4 h-4 group-hover:-translate-x-1 transition-transform" /> Back to Talent Library
                </button>

                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">

                    {/* Left: Profile Card */}
                    <div className="space-y-6">
                        <div className="bg-[#0c0c0e] border border-zinc-800 rounded-2xl p-6 text-center relative overflow-hidden">
                            <div className="absolute top-0 inset-x-0 h-1 bg-gradient-to-r from-indigo-500 to-purple-500"></div>

                            <div className="w-24 h-24 mx-auto bg-zinc-900 rounded-full flex items-center justify-center border-2 border-zinc-800 mb-4 shadow-xl overflow-hidden">
                                {profile.avatar_url ? (
                                    <img src={profile.avatar_url} alt={profile.full_name} className="w-full h-full object-cover" />
                                ) : (
                                    <span className="text-3xl font-bold text-zinc-400">{profile.full_name?.charAt(0)}</span>
                                )}
                            </div>

                            <h1 className="text-xl font-medium text-white mb-1">{profile.full_name}</h1>
                            <p className="text-sm text-zinc-500 mb-4">{profile.role}</p>

                            <div className="flex items-center justify-center gap-2 mb-6">
                                <span className="bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wide flex items-center gap-1">
                                    <ShieldCheck className="w-3 h-3" /> Verified
                                </span>
                            </div>

                            {/* Socials & Actions */}
                            <div className="flex gap-2 justify-center mb-6">
                                <button className="p-2 bg-zinc-900 border border-zinc-800 rounded-lg text-zinc-400 hover:text-white hover:border-zinc-700 transition-colors">
                                    <Github className="w-4 h-4" />
                                </button>
                                <button className="p-2 bg-zinc-900 border border-zinc-800 rounded-lg text-zinc-400 hover:text-white hover:border-zinc-700 transition-colors">
                                    <Globe className="w-4 h-4" />
                                </button>
                                <button
                                    onClick={() => onMessage(profile.id)}
                                    className="p-2 bg-zinc-900 border border-zinc-800 rounded-lg text-zinc-400 hover:text-white hover:border-zinc-700 transition-colors"
                                >
                                    <MessageSquare className="w-4 h-4" />
                                </button>
                            </div>

                            <button
                                onClick={() => onMessage(profile.id)}
                                className="w-full py-2.5 bg-white text-black rounded-xl font-medium hover:bg-zinc-200 transition-colors flex items-center justify-center gap-2"
                            >
                                Send Invite
                            </button>

                            <div className="mt-6 pt-6 border-t border-zinc-800/50 text-left space-y-4">
                                <div>
                                    <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-2">Primary Skills</h3>
                                    <div className="flex flex-wrap gap-1.5">
                                        {profile.skills && profile.skills.length > 0 ? (
                                            profile.skills.map((skill: string) => (
                                                <span key={skill} className="px-2 py-1 bg-zinc-900 border border-zinc-800 text-zinc-400 rounded-md text-xs">
                                                    {skill}
                                                </span>
                                            ))
                                        ) : (
                                            <span className="text-xs text-zinc-600 italic">No skills listed</span>
                                        )}
                                    </div>
                                </div>

                                <div>
                                    <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-2">About</h3>
                                    <p className="text-sm text-zinc-400 leading-relaxed">
                                        {profile.bio || "No bio description available."}
                                    </p>
                                </div>
                            </div>
                        </div>

                        {/* Stats */}
                        <div className="grid grid-cols-2 gap-4">
                            <div className="bg-zinc-900/30 border border-zinc-800/50 p-4 rounded-xl text-center">
                                <div className="text-2xl font-light text-white mb-1">{stats.dropsCompleted}</div>
                                <div className="text-[10px] text-zinc-500 uppercase tracking-widest">completed drops</div>
                            </div>
                            <div className="bg-zinc-900/30 border border-zinc-800/50 p-4 rounded-xl text-center">
                                <div className="text-2xl font-light text-emerald-400 mb-1">{stats.codeQualityScore}</div>
                                <div className="text-[10px] text-zinc-500 uppercase tracking-widest">Reputation Score</div>
                            </div>
                        </div>
                    </div>

                    {/* Right: Proof of Work */}
                    <div className="lg:col-span-2 space-y-6">
                        <h2 className="text-lg font-light text-zinc-100 flex items-center gap-2">
                            <Code2 className="w-5 h-5 text-zinc-500" /> Proof of Work
                        </h2>

                        <div className="space-y-4">
                            {portfolio.length > 0 ? (
                                portfolio.map((work: any) => (
                                    <div key={work.id} className="bg-[#0c0c0e] border border-zinc-800 rounded-xl p-6 hover:border-zinc-700 transition-all group">
                                        <div className="flex justify-between items-start mb-2">
                                            <div>
                                                <h3 className="text-base font-medium text-zinc-200 group-hover:text-white transition-colors">{work.title}</h3>
                                                <div className="flex items-center gap-2 text-xs text-zinc-500 mt-1">
                                                    {work.category && (
                                                        <>
                                                            <span className="text-zinc-400 font-medium">{work.category}</span>
                                                            <span>•</span>
                                                        </>
                                                    )}
                                                    <span>{new Date(work.created_at).toLocaleDateString()}</span>
                                                </div>
                                            </div>
                                            <div className="text-right">
                                                <div className="text-sm font-medium text-emerald-400">${work.bounty_amount || 0}</div>
                                                <div className="text-[10px] text-zinc-600 uppercase">Bounty Earned</div>
                                            </div>
                                        </div>

                                        <p className="text-sm text-zinc-400 leading-relaxed bg-zinc-900/50 p-3 rounded-lg border border-zinc-800/50 mb-4">
                                            "{work.description || "No description provided."}"
                                        </p>

                                        <div className="flex items-center gap-3">
                                            {work.is_private ? (
                                                <div className="flex items-center gap-2 px-3 py-1.5 bg-zinc-900/50 border border-zinc-800/50 rounded-lg text-xs font-medium text-zinc-500 cursor-not-allowed">
                                                    <Lock className="w-3.5 h-3.5" /> Private Repo
                                                </div>
                                            ) : (
                                                work.repo_url && (
                                                    <a href={work.repo_url} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1.5 px-3 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-xs font-medium text-zinc-400 hover:text-white hover:border-zinc-600 transition-colors">
                                                        <Github className="w-3.5 h-3.5" /> View Code
                                                    </a>
                                                )
                                            )}

                                            {work.demo_url && !work.is_private && (
                                                <a href={work.demo_url} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1.5 px-3 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-xs font-medium text-zinc-400 hover:text-white hover:border-zinc-600 transition-colors">
                                                    <ExternalLink className="w-3.5 h-3.5" /> Live Demo
                                                </a>
                                            )}
                                        </div>
                                    </div>
                                ))
                            ) : (
                                <div className="text-center py-12 border border-dashed border-zinc-800 rounded-xl text-zinc-500">
                                    No proof of work added yet.
                                </div>
                            )}
                        </div>
                    </div>

                </div>

            </div>
        );
    }

    // Sort: Pro members first
    const sortedTalents = filteredTalents.sort((a, b) => {
        if (a.subscription_tier === 'pro' && b.subscription_tier !== 'pro') return -1;
        if (a.subscription_tier !== 'pro' && b.subscription_tier === 'pro') return 1;
        return 0;
    });

    return (
        <div className="max-w-7xl mx-auto p-8 animate-in fade-in duration-500 text-white">
            <div className="flex items-center justify-between mb-8">
                <h1 className="text-3xl font-light">Talent Pool</h1>
                <div className="relative">
                    <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-zinc-500" />
                    <input
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="bg-[#111113] border border-zinc-800 rounded-xl py-2 pl-9 pr-4 text-sm text-white w-64 focus:outline-none focus:border-indigo-500 transition-colors"
                        placeholder="Search developers..."
                    />
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {sortedTalents.map(talent => {
                    const isPro = talent.subscription_tier === 'pro';
                    return (
                        <div
                            key={talent.id}
                            onClick={() => setSelectedTalent(talent)}
                            className={`bg-[#111113] border rounded-2xl p-6 transition-colors group cursor-pointer relative overflow-hidden ${isPro ? 'border-amber-500/30 hover:border-amber-500/60 shadow-[0_0_20px_-5px_rgba(245,158,11,0.1)]' : 'border-zinc-800 hover:border-zinc-700'}`}
                        >
                            {isPro && (
                                <div className="absolute top-0 right-0 bg-amber-500/10 text-amber-500 text-[10px] uppercase font-bold px-3 py-1 rounded-bl-xl border-l border-b border-amber-500/20 flex items-center gap-1 z-10">
                                    <Award className="w-3 h-3" /> Featured
                                </div>
                            )}

                            <div className="flex items-center gap-4 mb-4">
                                <div className="w-12 h-12 rounded-full bg-indigo-600 flex items-center justify-center font-bold text-lg overflow-hidden relative">
                                    {talent.avatar_url ? (
                                        <img src={talent.avatar_url} alt={talent.full_name} className="w-full h-full object-cover" />
                                    ) : (
                                        talent.full_name?.substring(0, 2)
                                    )}
                                </div>
                                <div>
                                    <h3 className="font-bold text-white group-hover:text-indigo-400 transition-colors flex items-center gap-2">
                                        {talent.full_name}
                                        {isPro && <Award className="w-4 h-4 text-amber-500" />}
                                    </h3>
                                    <p className="text-zinc-500 text-xs">{talent.role}</p>
                                </div>
                            </div>

                            <p className="text-sm text-zinc-400 line-clamp-2 mb-6 h-10">{talent.bio || "No bio yet."}</p>

                            <div className="flex gap-2">
                                <button onClick={(e) => { e.stopPropagation(); setSelectedTalent(talent); }} className="flex-1 bg-white text-black py-2 rounded-lg text-xs font-bold hover:bg-zinc-200 transition-colors">View Profile</button>
                                <button onClick={(e) => { e.stopPropagation(); onMessage(talent.id); }} className="p-2 border border-zinc-800 rounded-lg hover:bg-zinc-800 text-zinc-400 hover:text-white transition-colors"><Mail className="w-4 h-4" /></button>
                            </div>
                        </div>
                    );
                })}

                {filteredTalents.length === 0 && (
                    <div className="col-span-full text-center py-20 text-zinc-500">
                        No developers found matching "{searchTerm}".
                    </div>
                )}
            </div>
        </div>
    );
}
