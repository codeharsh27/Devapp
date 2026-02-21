
"use client";

import { CheckCircle2, Linkedin, Twitter, Link as LinkIcon, Download } from "lucide-react";
import { useRef } from "react";

export function ShareSuccessCard({ submission, onClose }: { submission: any, onClose: () => void }) {
    // In a real implementation, we would use html2canvas to capture this card as an image.

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm p-4">
            <div className="bg-[#0c0c0e] border border-zinc-800 rounded-3xl p-8 max-w-md w-full relative overflow-hidden">
                <div className="absolute top-0 right-0 -mt-10 -mr-10 w-40 h-40 bg-emerald-500/20 rounded-full blur-3xl"></div>

                <div className="text-center mb-8 relative z-10">
                    <div className="w-16 h-16 bg-emerald-500 rounded-full flex items-center justify-center mx-auto mb-4 shadow-[0_0_30px_rgba(16,185,129,0.3)]">
                        <CheckCircle2 className="w-8 h-8 text-white" />
                    </div>
                    <h2 className="text-2xl font-bold text-white mb-2">High Score Unlocked!</h2>
                    <p className="text-zinc-400 text-sm">You just crushed <span className="text-white font-medium">{submission.task.title}</span>.</p>
                </div>

                {/* The "Card" to Share */}
                <div className="bg-gradient-to-br from-zinc-900 to-black border border-zinc-800 rounded-2xl p-6 mb-8 relative group">
                    <div className="flex justify-between items-start mb-6">
                        <div>
                            <div className="text-xs text-zinc-500 font-bold uppercase tracking-wider mb-1">Mission</div>
                            <div className="text-white font-bold text-lg leading-tight">{submission.task.title}</div>
                        </div>
                        <div className="text-right">
                            <div className="text-xs text-zinc-500 font-bold uppercase tracking-wider mb-1">Score</div>
                            <div className="text-3xl font-mono text-emerald-400 font-bold">{submission.final_score}</div>
                        </div>
                    </div>

                    <div className="flex items-center gap-3 pt-6 border-t border-zinc-800/50">
                        <div className="w-8 h-8 rounded-full bg-indigo-600 flex items-center justify-center text-xs font-bold text-white">DA</div>
                        <div>
                            <div className="text-xs text-white mobile-app-logo">DevApp</div>
                            <div className="text-[10px] text-zinc-500">Top 1% Talent</div>
                        </div>
                    </div>
                </div>

                {/* Actions */}
                <div className="grid grid-cols-2 gap-3">
                    <button className="flex items-center justify-center gap-2 bg-[#0077b5] text-white py-3 rounded-xl text-sm font-bold hover:opacity-90 transition-opacity">
                        <Linkedin className="w-4 h-4" /> Share
                    </button>
                    <button className="flex items-center justify-center gap-2 bg-zinc-800 text-white py-3 rounded-xl text-sm font-bold hover:bg-zinc-700 transition-colors">
                        <Twitter className="w-4 h-4" /> Tweet
                    </button>
                    <button onClick={onClose} className="col-span-2 text-zinc-500 hover:text-white text-xs py-2 uppercase tracking-wide font-bold transition-colors">
                        Close
                    </button>
                </div>
            </div>
        </div>
    );
}
