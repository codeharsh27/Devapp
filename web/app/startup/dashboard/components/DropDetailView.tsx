
"use client";

import { useState } from "react";
import { X, Github, FileText, CheckCircle2, AlertCircle, MessageSquare, Award, Loader2 } from "lucide-react";
import { useTaskSubmissions } from "@/lib/hooks/useTaskSubmissions";
import { createSubmissionsService } from "@/lib/services/submissions";
import { createEvaluationService } from "@/lib/services/evaluation";
import { PageLoader } from "@/components/ui/PageLoader";

export function DropDetailView({ drop, onClose, onMessage }: { drop: any, onClose: () => void, onMessage: (uid: string) => void }) {
    const { submissions, loading } = useTaskSubmissions(drop.id);
    const [selectedSub, setSelectedSub] = useState<any | null>(null);
    const [isScoring, setIsScoring] = useState(false);

    // Scoring Form
    const [score, setScore] = useState(0);
    const [feedback, setFeedback] = useState("");

    const handleScore = async () => {
        if (!selectedSub) return;
        setIsScoring(true);
        try {
            const service = await createEvaluationService();
            await service.storeEvaluationResult(selectedSub.id, {
                score: score,
                log: feedback,
                status: 'evaluated'
            });
            alert("Submission Evaluated!");
            setSelectedSub(null);
            // Refresh logic would go here
        } catch (e: any) {
            console.error(e);
            alert("Error: " + e.message);
        } finally {
            setIsScoring(false);
        }
    };

    return (
        <div className="fixed inset-0 z-50 flex justify-end bg-black/50 backdrop-blur-sm animate-in fade-in duration-200">
            <div className="w-full max-w-2xl h-full bg-[#0c0c0e] border-l border-zinc-800 shadow-2xl overflow-y-auto animate-in slide-in-from-right duration-300 flex flex-col">

                {/* Header */}
                <div className="p-8 border-b border-zinc-800 flex justify-between items-start bg-[#0c0c0e] sticky top-0 z-10">
                    <div>
                        <h2 className="text-2xl font-bold text-white mb-2">{drop.title}</h2>
                        <div className="flex items-center gap-4 text-sm text-zinc-500">
                            <span className="capitalize">{drop.category}</span>
                            <span>•</span>
                            <span>{submissions.length} Submissions</span>
                        </div>
                    </div>
                    <button onClick={onClose} className="p-2 hover:bg-zinc-800 rounded-full text-zinc-500 hover:text-white transition-colors">
                        <X className="w-6 h-6" />
                    </button>
                </div>

                <div className="flex-1 overflow-y-auto p-8">

                    {/* Stats / Info */}
                    <div className="grid grid-cols-2 gap-4 mb-8">
                        <div className="p-4 rounded-xl bg-[#111113] border border-zinc-800">
                            <span className="text-xs text-zinc-500 uppercase tracking-wide block mb-1">Bounty</span>
                            <span className="text-lg font-mono text-emerald-400">{drop.bounty_amount ? `$${drop.bounty_amount}` : 'N/A'}</span>
                        </div>
                        <div className="p-4 rounded-xl bg-[#111113] border border-zinc-800">
                            <span className="text-xs text-zinc-500 uppercase tracking-wide block mb-1">Deadline</span>
                            <span className="text-lg font-mono text-white">{new Date(drop.deadline).toLocaleDateString()}</span>
                        </div>
                    </div>

                    <h3 className="text-lg font-bold text-white mb-4">Submissions</h3>

                    {loading ? <PageLoader /> : (
                        <div className="space-y-4">
                            {submissions.map(sub => (
                                <div key={sub.id} className="p-6 rounded-xl bg-[#111113] border border-zinc-800 hover:border-zinc-700 transition-colors">
                                    <div className="flex justify-between items-start mb-4">
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 rounded-full bg-indigo-600 flex items-center justify-center font-bold text-white">
                                                {sub.developer?.full_name?.substring(0, 2)}
                                            </div>
                                            <div>
                                                <div className="text-white font-medium">{sub.developer?.full_name}</div>
                                                <div className="text-xs text-zinc-500">{new Date(sub.created_at).toLocaleDateString()}</div>
                                            </div>
                                        </div>
                                        <div className={`px-2 py-1 rounded text-[10px] font-bold uppercase tracking-wide ${sub.status === 'evaluated' ? 'bg-emerald-500/10 text-emerald-400' : 'bg-amber-500/10 text-amber-400'}`}>
                                            {sub.status}
                                        </div>
                                    </div>

                                    <div className="space-y-3 mb-6">
                                        {sub.repo_url && (
                                            <a href={sub.repo_url} target="_blank" className="flex items-center gap-2 text-sm text-indigo-400 hover:text-indigo-300">
                                                <Github className="w-4 h-4" /> Repo Link
                                            </a>
                                        )}
                                        {sub.notes && (
                                            <p className="text-sm text-zinc-400 bg-zinc-900/50 p-3 rounded-lg">{sub.notes}</p>
                                        )}
                                    </div>

                                    {sub.status !== 'evaluated' && sub.status !== 'hired' ? (
                                        <div className="bg-zinc-900/50 p-4 rounded-xl border border-zinc-800">
                                            <h4 className="text-xs font-bold text-zinc-500 uppercase tracking-wide mb-3">Evaluate</h4>
                                            <div className="flex gap-4 mb-3">
                                                <input
                                                    type="number"
                                                    placeholder="Score (0-100)"
                                                    className="w-24 bg-black border border-zinc-800 rounded p-2 text-white outline-none"
                                                    onChange={(e) => { setSelectedSub(sub); setScore(Number(e.target.value)) }}
                                                />
                                                <input
                                                    type="text"
                                                    placeholder="Feedback (Optional)"
                                                    className="flex-1 bg-black border border-zinc-800 rounded p-2 text-white outline-none"
                                                    onChange={(e) => { setSelectedSub(sub); setFeedback(e.target.value) }}
                                                />
                                            </div>
                                            <button
                                                onClick={handleScore}
                                                disabled={isScoring}
                                                className="bg-white text-black px-4 py-2 rounded-lg text-sm font-bold hover:bg-zinc-200 transition-colors flex items-center gap-2"
                                            >
                                                {isScoring ? <Loader2 className="w-3 h-3 animate-spin" /> : <CheckCircle2 className="w-3 h-3" />}
                                                Submit Score
                                            </button>
                                        </div>
                                    ) : (
                                        <div className="flex items-center justify-between bg-zinc-900/30 p-4 rounded-xl border border-zinc-800">
                                            <div className="flex items-center gap-2 text-emerald-400 font-bold">
                                                <Award className="w-5 h-5" /> Score: {sub.final_score}
                                            </div>

                                            {sub.status === 'evaluated' && (
                                                <button
                                                    onClick={async () => {
                                                        const { createClient } = await import("@/lib/supabase/client");
                                                        const supabase = createClient();
                                                        await supabase.from('submissions').update({ status: 'hired' }).eq('id', sub.id);
                                                        onMessage(sub.developer?.id); // Open chat
                                                        alert("Talent Hired! Chat opened.");
                                                        // In real app, trigger refresh
                                                    }}
                                                    className="bg-indigo-600 hover:bg-indigo-500 text-white px-4 py-2 rounded-lg text-sm font-bold transition-colors flex items-center gap-2"
                                                >
                                                    Hire Talent
                                                </button>
                                            )}

                                            {sub.status === 'hired' && (
                                                <div className="px-3 py-1 bg-indigo-500/20 text-indigo-400 rounded-md text-xs font-bold uppercase tracking-wider border border-indigo-500/30">
                                                    Hired
                                                </div>
                                            )}
                                        </div>
                                    )}
                                </div>
                            ))}

                            {submissions.length === 0 && <div className="text-zinc-500">No submissions yet.</div>}
                        </div>
                    )}

                </div>
            </div>
        </div>
    );
}
