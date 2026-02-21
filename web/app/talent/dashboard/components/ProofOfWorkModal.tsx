"use client";
import { X, Share2, Award, CheckCircle2 } from "lucide-react";

export function ProofOfWorkModal({ submission, onClose }: { submission: any, onClose: () => void }) {
    if (!submission) return null;

    const task = submission.task;
    const startupName = task.startup?.full_name || "a Stealth Startup";
    const score = submission.final_score;

    const shareUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(`I just scored ${score}/100 on DevApp helping ${startupName} build their ${task.title}! 🚀\n\nCheck out my proof of work:`)}`;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm p-4 animate-in fade-in">
            <div className="relative w-full max-w-md bg-[#0c0c0e] border border-zinc-800 rounded-2xl overflow-hidden shadow-2xl animate-in zoom-in-95 duration-200">

                {/* Close */}
                <button onClick={onClose} className="absolute top-4 right-4 text-zinc-500 hover:text-white z-10 transition-colors">
                    <X className="w-5 h-5" />
                </button>

                {/* The "Card" Area - Visual */}
                <div className="bg-gradient-to-br from-[#1c1c1f] to-[#000] p-8 text-center relative overflow-hidden group selection:bg-indigo-500/30">
                    {/* Decorative Blobs */}
                    <div className="absolute top-0 right-0 w-40 h-40 bg-indigo-500/20 blur-[60px] rounded-full -translate-y-1/2 translate-x-1/2"></div>
                    <div className="absolute bottom-0 left-0 w-40 h-40 bg-amber-500/10 blur-[60px] rounded-full translate-y-1/2 -translate-x-1/2"></div>

                    {/* Badge */}
                    <div className="inline-flex items-center gap-2 bg-amber-500/10 text-amber-500 border border-amber-500/20 px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest mb-6 shadow-[0_0_15px_-3px_rgba(245,158,11,0.3)]">
                        <Award className="w-3 h-3" /> Verified Proof of Work
                    </div>

                    <h2 className="text-zinc-500 text-xs mb-3 font-mono uppercase tracking-wider">Mission Complete</h2>

                    <h1 className="text-xl md:text-2xl font-bold text-white mb-2 leading-tight">
                        {task.title}
                    </h1>

                    <p className="text-zinc-400 text-sm mb-8">
                        Built for <span className="text-indigo-400 font-medium">{startupName}</span>
                    </p>

                    <div className="flex justify-center mb-8">
                        <div className="relative group/score cursor-default">
                            <div className="w-28 h-28 rounded-full border-4 border-zinc-800/80 flex items-center justify-center bg-[#111] shadow-2xl group-hover/score:border-emerald-500/50 transition-colors duration-500">
                                <span className="text-5xl font-bold text-white bg-clip-text text-transparent bg-gradient-to-br from-emerald-400 to-emerald-600 drop-shadow-sm">{score}</span>
                            </div>
                            <div className="absolute -bottom-3 -right-3 bg-zinc-900 text-zinc-400 text-[10px] font-bold px-3 py-1 rounded-lg border border-zinc-800 uppercase tracking-widest shadow-xl">
                                Score
                            </div>
                        </div>
                    </div>

                    <div className="flex items-center justify-center gap-2 text-[10px] text-zinc-600 uppercase tracking-widest font-mono">
                        <CheckCircle2 className="w-3 h-3 text-emerald-500" /> Contract Fulfilled
                    </div>
                </div>

                {/* Footer / Actions */}
                <div className="p-6 bg-[#111113] border-t border-zinc-800">
                    <p className="text-xs text-zinc-500 text-center mb-4">
                        Share this achievement to build your reputation.
                    </p>
                    <a
                        href={shareUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="flex items-center justify-center gap-2 w-full bg-white text-black font-bold py-3 rounded-xl hover:bg-zinc-200 transition-colors text-sm"
                    >
                        <Share2 className="w-4 h-4" /> Share on X
                    </a>
                </div>
            </div>
        </div>
    );
}
