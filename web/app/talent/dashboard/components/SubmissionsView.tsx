
"use client";
import { useTalentSubmissions } from "@/lib/hooks/useTalentSubmissions";
import { PageLoader } from "@/components/ui/PageLoader";
import { useState, useEffect, useTransition } from "react";
import { createSubmissionsService } from "@/lib/services/submissions";
import { ExternalLink, Terminal, Loader2, Send, CheckCircle2, Share2, AlertTriangle, XCircle } from "lucide-react";
import { ShareSuccessCard } from "@/components/ShareSuccessCard";
import { createClient } from "@/lib/supabase/client";
import { submitWorkAction } from "@/app/actions/missions";
import { toast } from "sonner";

export function SubmissionsView({ userId }: { userId: string | undefined }) {
    const { submissions, loading, refetch } = useTalentSubmissions(userId);
    const [selectedSubmission, setSelectedSubmission] = useState<any | null>(null);

    // Logs State
    const [logs, setLogs] = useState<any[]>([]);
    const [loadingLogs, setLoadingLogs] = useState(false);

    // Edit State
    const [repoUrl, setRepoUrl] = useState("");
    const [notes, setNotes] = useState("");
    const [isSubmitting, startTransition] = useTransition();
    const [showShare, setShowShare] = useState(false);

    const openSubmission = (sub: any) => {
        setSelectedSubmission(sub);
        setRepoUrl(sub.repo_url || "");
        setNotes(sub.notes || "");
        // Fetch logs if evaluated
        if (sub.status === 'evaluated' || sub.status === 'failed') {
            fetchLogs(sub.id);
        } else {
            setLogs([]);
        }
    };

    const fetchLogs = async (submissionId: string) => {
        setLoadingLogs(true);
        const supabase = createClient();
        const { data } = await supabase
            .from('evaluation_logs')
            .select('*')
            .eq('submission_id', submissionId)
            .order('created_at', { ascending: true });
        if (data) setLogs(data);
        setLoadingLogs(false);
    };

    const submitWork = () => {
        if (!selectedSubmission || !userId) return;

        startTransition(async () => {
            const result = await submitWorkAction(selectedSubmission.id, { repo_url: repoUrl, notes });
            if (result.error) {
                toast.error(result.error);
            } else {
                toast.success("Successfully submitted work!");
                await refetch();
                setSelectedSubmission((prev: any) => ({ ...prev, status: 'pending', repo_url: repoUrl, notes }));
            }
        });
    };

    if (loading) return <PageLoader />;

    return (
        <div className="max-w-7xl mx-auto p-8 text-white font-sans animate-in fade-in duration-500">
            <h1 className="text-3xl font-light text-white mb-6">My Submissions</h1>

            {selectedSubmission ? (
                <div className="max-w-3xl bg-[#0c0c0e] border border-zinc-800 rounded-2xl p-8 relative">
                    <button onClick={() => setSelectedSubmission(null)} className="absolute top-8 right-8 text-zinc-500 hover:text-white transition-colors">
                        <XCircle className="w-6 h-6" />
                    </button>
                    <button onClick={() => setSelectedSubmission(null)} className="text-zinc-500 text-xs mb-6 hover:text-white uppercase font-bold flex items-center gap-2">
                        ← Back to List
                    </button>

                    <h2 className="text-2xl font-bold mb-2">{selectedSubmission.task.title}</h2>
                    <p className="text-zinc-500 mb-8">{selectedSubmission.task.description}</p>

                    {(selectedSubmission.status === 'evaluated' || selectedSubmission.status === 'failed') ? (
                        <div className="space-y-6">
                            <div className={`p-6 border rounded-xl text-center ${selectedSubmission.status === 'evaluated' ? 'bg-emerald-500/10 border-emerald-500/20' : 'bg-red-500/10 border-red-500/20'}`}>
                                {selectedSubmission.status === 'evaluated' ? (
                                    <CheckCircle2 className="w-8 h-8 text-emerald-500 mx-auto mb-2" />
                                ) : (
                                    <AlertTriangle className="w-8 h-8 text-red-500 mx-auto mb-2" />
                                )}
                                <div className="text-3xl font-bold text-white mb-1">{selectedSubmission.final_score || 0}<span className="text-lg text-zinc-500">/100</span></div>
                                <div className={`text-sm font-bold uppercase tracking-wide mb-4 ${selectedSubmission.status === 'evaluated' ? 'text-emerald-400' : 'text-red-400'}`}>
                                    {selectedSubmission.status === 'evaluated' ? 'Passed' : 'Needs Improvement'}
                                </div>

                                {selectedSubmission.final_score >= 80 && (
                                    <button onClick={() => setShowShare(true)} className="flex items-center justify-center gap-2 mx-auto bg-indigo-600 text-white px-6 py-2 rounded-full font-bold hover:bg-indigo-500 transition-all shadow-lg shadow-indigo-500/20 animate-pulse">
                                        <Share2 className="w-4 h-4" /> Share Your Win
                                    </button>
                                )}
                            </div>

                            {/* Report Card / Logs */}
                            <div className="bg-[#111] border border-zinc-800 rounded-xl overflow-hidden">
                                <div className="px-4 py-3 border-b border-zinc-800 bg-zinc-900/50 flex items-center gap-2">
                                    <Terminal className="w-4 h-4 text-zinc-500" />
                                    <span className="text-xs font-bold text-zinc-400 uppercase tracking-wider">Evaluation Logs</span>
                                </div>
                                <div className="p-4 space-y-2 font-mono text-xs max-h-60 overflow-y-auto">
                                    {loadingLogs ? (
                                        <div className="flex items-center gap-2 text-zinc-500">
                                            <Loader2 className="w-3 h-3 animate-spin" /> Fetching logs...
                                        </div>
                                    ) : logs.length > 0 ? (
                                        logs.map((log, i) => (
                                            <div key={i} className="flex gap-3">
                                                <span className={log.status === 'success' ? 'text-emerald-500' : 'text-red-500'}>
                                                    [{log.status.toUpperCase()}]
                                                </span>
                                                <span className="text-zinc-300">{log.step_name}:</span>
                                                <span className="text-zinc-500">{log.output_log || 'No output'}</span>
                                            </div>
                                        ))
                                    ) : (
                                        <div className="text-zinc-600 italic">No detailed logs available.</div>
                                    )}
                                </div>
                            </div>
                        </div>
                    ) : (
                        <div className="space-y-4 mb-8">
                            {selectedSubmission.status === 'processing' && (
                                <div className="bg-indigo-500/10 border border-indigo-500/20 p-4 rounded-lg flex items-center gap-3 text-indigo-300 mb-4 animate-pulse">
                                    <Loader2 className="w-5 h-5 animate-spin" />
                                    <span>Your submission is currently being evaluated by our systems...</span>
                                </div>
                            )}

                            <div>
                                <label className="block text-xs font-bold text-zinc-500 uppercase tracking-wide mb-2">Repo URL</label>
                                <input
                                    value={repoUrl}
                                    onChange={e => setRepoUrl(e.target.value)}
                                    disabled={selectedSubmission.status === 'processing'}
                                    className="w-full bg-[#111113] border border-zinc-800 rounded-lg p-3 text-white focus:border-indigo-500 outline-none disabled:opacity-50"
                                    placeholder="https://github.com/..."
                                />
                            </div>
                            <div>
                                <label className="block text-xs font-bold text-zinc-500 uppercase tracking-wide mb-2">Notes</label>
                                <textarea
                                    value={notes}
                                    onChange={e => setNotes(e.target.value)}
                                    disabled={selectedSubmission.status === 'processing'}
                                    className="w-full bg-[#111113] border border-zinc-800 rounded-lg p-3 text-white focus:border-indigo-500 outline-none h-32 disabled:opacity-50"
                                    placeholder="Approach notes..."
                                />
                            </div>

                            {selectedSubmission.status !== 'processing' && (
                                <button onClick={submitWork} disabled={isSubmitting} className="bg-white text-black px-6 py-3 rounded-xl font-bold hover:bg-zinc-200 transition-colors w-full flex items-center justify-center gap-2">
                                    {isSubmitting ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send className="w-4 h-4" />}
                                    {selectedSubmission.status === 'enrolled' ? 'Submit Work' : 'Update Submission'}
                                </button>
                            )}
                        </div>
                    )}
                </div>
            ) : (
                <div className="space-y-4">
                    {submissions.map(sub => (
                        <div key={sub.id} onClick={() => openSubmission(sub)} className="bg-[#111113] border border-zinc-800 hover:border-zinc-600 p-6 rounded-xl cursor-pointer transition-colors flex justify-between items-center group">
                            <div>
                                <h3 className="text-lg font-medium text-white group-hover:text-indigo-300 transition-colors">{sub.task.title}</h3>
                                <div className="flex items-center gap-3 mt-1 text-sm text-zinc-500">
                                    <span>{sub.task.startup?.full_name}</span>
                                    <span>•</span>
                                    <span className={`capitalize font-bold ${sub.status === 'evaluated' ? 'text-emerald-500' : 'text-zinc-400'}`}>{sub.status}</span>
                                </div>
                            </div>
                            <div className="text-right">
                                {sub.final_score && <div className="text-xl font-mono text-emerald-400 font-bold">{sub.final_score}</div>}
                                {!sub.final_score && <div className="text-xs text-zinc-600 uppercase tracking-wider font-bold">Processing</div>}
                            </div>
                        </div>
                    ))}

                    {submissions.length === 0 && <div className="text-zinc-500 border border-dashed border-zinc-800 rounded-xl p-12 text-center">No submissions yet. Go to 'Explore Drops' to start a mission!</div>}
                </div>
            )}

            {showShare && selectedSubmission && (
                <ShareSuccessCard submission={selectedSubmission} onClose={() => setShowShare(false)} />
            )}
        </div>
    );
}
