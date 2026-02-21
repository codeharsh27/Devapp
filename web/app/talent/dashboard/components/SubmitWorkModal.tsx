"use client";
import { useState } from "react";
import { X, UploadCloud, Link as LinkIcon, FileText, CheckCircle2, AlertCircle } from "lucide-react";
import { Space_Grotesk } from "next/font/google";

const spaceGrotesk = Space_Grotesk({
    subsets: ["latin"],
    weight: ["300", "400", "500", "600", "700"],
});

interface SubmitWorkModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSubmit: (data: SubmissionData) => void;
    missionTitle: string;
}

export interface SubmissionData {
    repoLink: string;
    deployedLink: string;
    notes: string;
    docLink: string;
}

export function SubmitWorkModal({ isOpen, onClose, onSubmit, missionTitle }: SubmitWorkModalProps) {
    const [repoLink, setRepoLink] = useState("");
    const [deployedLink, setDeployedLink] = useState("");
    const [notes, setNotes] = useState("");
    const [docLink, setDocLink] = useState("");

    if (!isOpen) return null;

    const handleSubmit = () => {
        onSubmit({
            repoLink,
            deployedLink,
            notes,
            docLink
        });
        onClose();
    };

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm animate-in fade-in duration-300">
            <div className="w-full max-w-2xl bg-[#0c0c0e] border border-zinc-800 rounded-3xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">

                {/* Header */}
                <div className="flex items-center justify-between px-8 py-6 border-b border-zinc-800 bg-zinc-900/30">
                    <div>
                        <h2 className={`text-xl font-bold text-white ${spaceGrotesk.className}`}>Submit Work</h2>
                        <p className="text-sm text-zinc-400 mt-1">For mission: <span className="text-indigo-400">{missionTitle}</span></p>
                    </div>
                    <button onClick={onClose} className="p-2 rounded-full hover:bg-zinc-800 text-zinc-500 hover:text-white transition-colors">
                        <X className="w-5 h-5" />
                    </button>
                </div>

                {/* Body */}
                <div className="p-8 overflow-y-auto space-y-6 custom-scrollbar">

                    {/* Repository Link */}
                    <div className="space-y-2">
                        <label className="text-sm font-medium text-zinc-300 flex items-center gap-2">
                            <GithubIcon className="w-4 h-4" /> Repository Link <span className="text-red-500">*</span>
                        </label>
                        <input
                            value={repoLink}
                            onChange={(e) => setRepoLink(e.target.value)}
                            placeholder="e.g. https://github.com/username/repo"
                            className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl px-4 py-3 text-sm text-white focus:border-indigo-500/50 focus:ring-1 focus:ring-indigo-500/20 outline-none transition-all placeholder:text-zinc-600"
                        />
                    </div>

                    {/* Deployed Link (Optional) */}
                    <div className="space-y-2">
                        <label className="text-sm font-medium text-zinc-300 flex items-center gap-2">
                            <LinkIcon className="w-4 h-4" /> Live Demo / Deployment
                        </label>
                        <input
                            value={deployedLink}
                            onChange={(e) => setDeployedLink(e.target.value)}
                            placeholder="e.g. https://my-project.vercel.app"
                            className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl px-4 py-3 text-sm text-white focus:border-indigo-500/50 focus:ring-1 focus:ring-indigo-500/20 outline-none transition-all placeholder:text-zinc-600"
                        />
                    </div>

                    {/* Document Link */}
                    <div className="space-y-2">
                        <label className="text-sm font-medium text-zinc-300 flex items-center gap-2">
                            <FileText className="w-4 h-4" /> Design File / Document Link
                        </label>
                        <input
                            value={docLink}
                            onChange={(e) => setDocLink(e.target.value)}
                            placeholder="e.g. Figma, Google Doc, Notion link..."
                            className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl px-4 py-3 text-sm text-white focus:border-indigo-500/50 focus:ring-1 focus:ring-indigo-500/20 outline-none transition-all placeholder:text-zinc-600"
                        />
                        <p className="text-xs text-zinc-500 flex items-center gap-1.5">
                            <AlertCircle className="w-3 h-3" />
                            <span>Please ensure the link is accessible (public or shared with reviewer).</span>
                        </p>
                    </div>

                    {/* Notes */}
                    <div className="space-y-2">
                        <label className="text-sm font-medium text-zinc-300">Notes for the Reviewer</label>
                        <textarea
                            value={notes}
                            onChange={(e) => setNotes(e.target.value)}
                            rows={4}
                            className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl px-4 py-3 text-sm text-white focus:border-indigo-500/50 focus:ring-1 focus:ring-indigo-500/20 outline-none transition-all resize-none placeholder:text-zinc-600"
                            placeholder="Explain your implementation details, any challenges faced, or specific areas to review..."
                        />
                    </div>
                </div>

                {/* Footer */}
                <div className="p-6 border-t border-zinc-800 bg-zinc-900/30 flex justify-end gap-3 backdrop-blur-sm">
                    <button onClick={onClose} className="px-6 py-2.5 rounded-xl text-sm font-medium text-zinc-400 hover:text-white hover:bg-zinc-800 transition-colors">
                        Cancel
                    </button>
                    <button
                        onClick={handleSubmit}
                        disabled={!repoLink}
                        className="px-6 py-2.5 rounded-xl text-sm font-bold text-black bg-white hover:bg-zinc-200 transition-colors shadow-lg shadow-indigo-500/10 hover:shadow-indigo-500/20 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        Submit Mission
                    </button>
                </div>
            </div>
        </div>
    );
}

// Simple internal icon component to avoid huge import lists just for one icon in this file
function GithubIcon({ className }: { className?: string }) {
    return (
        <svg className={className} xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4" />
            <path d="M9 18c-4.51 2-5-2-7-2" />
        </svg>
    )
}
