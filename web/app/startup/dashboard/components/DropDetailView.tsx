"use client";

import { useState, useEffect } from "react";
import { X, MessageSquare, ExternalLink, Users, Clock, ArrowUpRight, Loader2, CheckCircle2, AlertCircle } from "lucide-react";
import { useRouter } from "next/navigation";

interface DropDetailViewProps {
    drop: any;
    onClose: () => void;
    onMessage: (userId: string) => void;
}

export function DropDetailView({ drop, onClose, onMessage }: DropDetailViewProps) {
    const router = useRouter();
    const [activeTab, setActiveTab] = useState<'submissions' | 'details'>('submissions');
    const [submissions, setSubmissions] = useState<any[]>([]);
    const [loadingSubs, setLoadingSubs] = useState(true);

    // Fetch submissions for this drop
    useEffect(() => {
        const fetchSubmissions = async () => {
            const { createClient } = await import("@/lib/supabase/client");
            const supabase = createClient();
            
            const { data } = await supabase
                .from("submissions")
                .select(`
                    id, status, final_score, created_at,
                    developer:profiles(id, full_name, avatar_url, username)
                `)
                .eq("task_id", drop.id)
                .order("final_score", { ascending: false });

            if (data) setSubmissions(data);
            setLoadingSubs(false);
        };
        fetchSubmissions();
    }, [drop.id]);

    const getStatusColor = (status: string) => {
        switch (status) {
            case "enrolled": return "bg-amber-500/10 text-amber-400 border-amber-500/20";
            case "pending": return "bg-indigo-500/10 text-indigo-400 border-indigo-500/20";
            case "processing": return "bg-blue-500/10 text-blue-400 border-blue-500/20";
            case "evaluated": return "bg-emerald-500/10 text-emerald-400 border-emerald-500/20";
            case "failed": return "bg-red-500/10 text-red-400 border-red-500/20";
            case "hired": return "bg-purple-500/10 text-purple-400 border-purple-500/20";
            default: return "bg-zinc-500/10 text-zinc-400 border-zinc-500/20";
        }
    };

    return (
        <div className="fixed inset-0 z-50 flex justify-end bg-black/50 backdrop-blur-sm animate-in fade-in duration-200">
            <div className="w-full max-w-2xl h-full bg-[#0c0c0e] border-l border-zinc-800 shadow-2xl overflow-y-auto animate-in slide-in-from-right duration-300">
                {/* Header */}
                <div className="sticky top-0 z-10 bg-[#0c0c0e]/95 backdrop-blur border-b border-zinc-800 p-6">
                    <div className="flex items-start justify-between">
                        <div>
                            <div className="flex items-center gap-2 mb-2">
                                <span className="bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 px-2 py-0.5 rounded text-[10px] font-bold uppercase">
                                    {drop.status}
                                </span>
                                <span className="text-zinc-500 text-xs font-mono uppercase tracking-wider">
                                    {drop.category}
                                </span>
                            </div>
                            <h2 className="text-xl font-semibold text-white">{drop.title}</h2>
                        </div>
                        <button 
                            onClick={onClose} 
                            className="p-2 hover:bg-zinc-800 rounded-full text-zinc-500 hover:text-white transition-colors"
                        >
                            <X className="w-5 h-5" />
                        </button>
                    </div>

                    {/* Tabs */}
                    <div className="flex gap-4 mt-4 border-b border-zinc-800">
                        <button
                            onClick={() => setActiveTab('submissions')}
                            className={`pb-3 text-sm font-medium transition-colors border-b-2 ${
                                activeTab === 'submissions' 
                                    ? 'text-white border-white' 
                                    : 'text-zinc-500 border-transparent hover:text-zinc-300'
                            }`}
                        >
                            Submissions ({submissions.length})
                        </button>
                        <button
                            onClick={() => setActiveTab('details')}
                            className={`pb-3 text-sm font-medium transition-colors border-b-2 ${
                                activeTab === 'details' 
                                    ? 'text-white border-white' 
                                    : 'text-zinc-500 border-transparent hover:text-zinc-300'
                            }`}
                        >
                            Details
                        </button>
                    </div>
                </div>

                {/* Content */}
                <div className="p-6">
                    {activeTab === 'submissions' && (
                        <div className="space-y-4">
                            {loadingSubs ? (
                                <div className="flex items-center justify-center py-10">
                                    <Loader2 className="w-6 h-6 animate-spin text-zinc-500" />
                                </div>
                            ) : submissions.length === 0 ? (
                                <div className="text-center py-10 text-zinc-500 border border-dashed border-zinc-800 rounded-xl">
                                    <Users className="w-8 h-8 mx-auto mb-3 opacity-30" />
                                    <p className="text-sm">No submissions yet</p>
                                </div>
                            ) : (
                                submissions.map((sub) => (
                                    <div 
                                        key={sub.id}
                                        className="bg-[#111113] border border-zinc-800 rounded-xl p-4 hover:border-zinc-700 transition-colors"
                                    >
                                        <div className="flex items-start justify-between">
                                            <div className="flex items-start gap-3">
                                                <div className="w-10 h-10 rounded-full bg-zinc-800 flex items-center justify-center text-sm font-bold text-zinc-400 uppercase">
                                                    {sub.developer?.full_name?.substring(0, 2) || "?"}
                                                </div>
                                                <div>
                                                    <h4 className="text-sm font-medium text-zinc-200">
                                                        {sub.developer?.full_name || "Anonymous Developer"}
                                                    </h4>
                                                    <p className="text-xs text-zinc-500 mt-0.5">
                                                        {new Date(sub.created_at).toLocaleDateString()}
                                                    </p>
                                                </div>
                                            </div>
                                            <div className="flex items-center gap-2">
                                                <span className={`px-2 py-1 rounded text-[10px] font-bold uppercase border ${getStatusColor(sub.status)}`}>
                                                    {sub.status}
                                                </span>
                                                {sub.final_score !== null && (
                                                    <span className="text-sm font-mono text-zinc-400">
                                                        {sub.final_score}pts
                                                    </span>
                                                )}
                                            </div>
                                        </div>
                                        
                                        {sub.status === 'pending' || sub.status === 'processing' || sub.status === 'evaluated' ? (
                                            <div className="mt-3 pt-3 border-t border-zinc-800 flex gap-2">
                                                <button
                                                    onClick={() => onMessage(sub.developer?.id)}
                                                    className="flex items-center gap-1 text-xs text-indigo-400 hover:text-indigo-300 transition-colors"
                                                >
                                                    <MessageSquare className="w-3 h-3" />
                                                    Message
                                                </button>
                                                {sub.developer?.username && (
                                                    <a
                                                        href={`https://github.com/${sub.developer.username}`}
                                                        target="_blank"
                                                        rel="noopener noreferrer"
                                                        className="flex items-center gap-1 text-xs text-zinc-500 hover:text-zinc-300 transition-colors"
                                                    >
                                                        <ExternalLink className="w-3 h-3" />
                                                        View Profile
                                                    </a>
                                                )}
                                            </div>
                                        ) : null}
                                    </div>
                                ))
                            )}
                        </div>
                    )}

                    {activeTab === 'details' && (
                        <div className="space-y-6">
                            <div>
                                <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Description</h3>
                                <p className="text-sm text-zinc-300 leading-relaxed">
                                    {drop.description || "No description provided."}
                                </p>
                            </div>

                            <div className="grid grid-cols-2 gap-4">
                                <div className="bg-[#111113] border border-zinc-800 rounded-xl p-4">
                                    <span className="text-xs font-bold text-zinc-500 uppercase tracking-wider block mb-2">Difficulty</span>
                                    <span className="text-sm text-zinc-300 capitalize">
                                        {drop.difficulty_level || 1}
                                    </span>
                                </div>
                                <div className="bg-[#111113] border border-zinc-800 rounded-xl p-4">
                                    <span className="text-xs font-bold text-zinc-500 uppercase tracking-wider block mb-2">Est. Hours</span>
                                    <span className="text-sm text-zinc-300">
                                        {drop.estimated_hours || "Flexible"}
                                    </span>
                                </div>
                            </div>

                            {drop.requirements && drop.requirements.length > 0 && (
                                <div>
                                    <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Requirements</h3>
                                    <ul className="space-y-2">
                                        {drop.requirements.map((req: string, i: number) => (
                                            <li key={i} className="flex items-start gap-2 text-sm text-zinc-400">
                                                <CheckCircle2 className="w-4 h-4 text-indigo-500 mt-0.5 shrink-0" />
                                                {req}
                                            </li>
                                        ))}
                                    </ul>
                                </div>
                            )}

                            {drop.bounty_amount > 0 && (
                                <div className="bg-emerald-500/10 border border-emerald-500/20 rounded-xl p-4">
                                    <span className="text-xs font-bold text-emerald-500 uppercase tracking-wider block mb-1">Bounty</span>
                                    <span className="text-2xl font-mono text-emerald-400 font-bold">
                                        ${drop.bounty_amount}
                                    </span>
                                </div>
                            )}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
