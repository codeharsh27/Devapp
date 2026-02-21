"use client";

import { motion, AnimatePresence } from "framer-motion";
import { X, Network, ShieldCheck, GitCommit } from "lucide-react";
import { useEffect } from "react";

export default function ProtocolModal({ isOpen, onClose }: { isOpen: boolean, onClose: () => void }) {
    useEffect(() => {
        const handleEsc = (e: KeyboardEvent) => {
            if (e.key === "Escape") onClose();
        };
        window.addEventListener("keydown", handleEsc);
        return () => window.removeEventListener("keydown", handleEsc);
    }, [onClose]);

    return (
        <AnimatePresence>
            {isOpen && (
                <>
                    {/* Backdrop */}
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        onClick={onClose}
                        className="fixed inset-0 bg-black/90 backdrop-blur-sm z-[100]"
                    />

                    {/* Modal Content */}
                    <motion.div
                        initial={{ opacity: 0, scale: 0.95, y: 20 }}
                        animate={{ opacity: 1, scale: 1, y: 0 }}
                        exit={{ opacity: 0, scale: 0.95, y: 20 }}
                        className="fixed inset-0 md:inset-10 z-[101] flex items-center justify-center pointer-events-none p-4"
                    >
                        <div className="bg-[#111] w-full max-w-2xl h-full md:h-auto max-h-[90vh] rounded-2xl border border-white/10 shadow-2xl overflow-hidden flex flex-col pointer-events-auto">

                            {/* Header */}
                            <div className="flex items-center justify-between px-6 py-4 border-b border-white/10 bg-[#0A0A0A]">
                                <div className="flex items-center gap-2 text-white font-mono text-sm">
                                    <Network className="w-4 h-4 text-blue-500" />
                                    <span>protocol_v1.md</span>
                                </div>
                                <button onClick={onClose} className="text-gray-500 hover:text-white transition-colors">
                                    <X className="w-5 h-5" />
                                </button>
                            </div>

                            {/* Scrollable Content */}
                            <div className="overflow-y-auto p-8 md:p-12 space-y-8 text-gray-300 leading-relaxed font-light">
                                <div>
                                    <h2 className="text-3xl text-white font-bold mb-4 tracking-tighter">The Delegation Protocol.</h2>
                                    <p>
                                        DevApp is not an agency. It is a decentralized protocol for elastic engineering capacity. We route units of work (Drops) to the optimal execution node (Developer) based on reputation and skill signatures.
                                    </p>
                                </div>

                                <div className="space-y-6">
                                    <div className="flex gap-4">
                                        <div className="mt-1"><GitCommit className="w-5 h-5 text-blue-500" /></div>
                                        <div>
                                            <h3 className="text-lg text-white font-bold">1. Atomic Units of Work</h3>
                                            <p className="text-sm mt-1 text-gray-400">
                                                Work is defined as single, mergeable Pull Requests. No hourly billing. No meetings. The deliverable is the code itself, verified by the startup&apos;s CI/CD pipeline.
                                            </p>
                                        </div>
                                    </div>

                                    <div className="flex gap-4">
                                        <div className="mt-1"><ShieldCheck className="w-5 h-5 text-green-500" /></div>
                                        <div>
                                            <h3 className="text-lg text-white font-bold">2. Proof of Execution</h3>
                                            <p className="text-sm mt-1 text-gray-400">
                                                Reputation is non-transferable and mathematically derived from successful merges. A developer&apos;s &quot;Level&quot; is a direct function of the complexity and value of delivered code.
                                            </p>
                                        </div>
                                    </div>

                                    <div className="flex gap-4">
                                        <div className="mt-1"><Network className="w-5 h-5 text-purple-500" /></div>
                                        <div>
                                            <h3 className="text-lg text-white font-bold">3. Zero-Trust Verification</h3>
                                            <p className="text-sm mt-1 text-gray-400">
                                                The protocol assumes no trust between parties. Payment is held in escrow and released atomicially upon PR merge. Code is verified by automated test suites before human review.
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div className="pt-8 border-t border-white/10 text-center">
                                    <p className="font-mono text-xs text-blue-500 mb-2">network_status: ONLINE</p>
                                    <button
                                        onClick={onClose}
                                        className="bg-white text-black px-8 py-3 font-bold uppercase tracking-widest text-xs hover:bg-gray-200 transition-colors"
                                    >
                                        Close Protocol
                                    </button>
                                </div>
                            </div>

                        </div>
                    </motion.div>
                </>
            )}
        </AnimatePresence>
    );
}
