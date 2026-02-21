"use client";

import { motion, AnimatePresence } from "framer-motion";
import { X, Scale, FileText, Lock } from "lucide-react";
import { useEffect, useState } from "react";

export default function LegalModal({ isOpen, onClose }: { isOpen: boolean, onClose: () => void }) {
    const [activeTab, setActiveTab] = useState<'terms' | 'privacy'>('terms');

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
                            <div className="px-6 py-4 border-b border-white/10 bg-[#0A0A0A] flex flex-col gap-4">
                                <div className="flex items-center justify-between">
                                    <div className="flex items-center gap-2 text-white font-mono text-sm">
                                        <Scale className="w-4 h-4 text-gray-400" />
                                        <span>legal_doc_bundle.pdf</span>
                                    </div>
                                    <button onClick={onClose} className="text-gray-500 hover:text-white transition-colors">
                                        <X className="w-5 h-5" />
                                    </button>
                                </div>
                                <div className="flex gap-4 text-xs font-bold uppercase tracking-widest">
                                    <button
                                        onClick={() => setActiveTab('terms')}
                                        className={`pb-2 border-b-2 transition-colors ${activeTab === 'terms' ? 'border-white text-white' : 'border-transparent text-gray-500 hover:text-white'}`}
                                    >
                                        Terms of Service
                                    </button>
                                    <button
                                        onClick={() => setActiveTab('privacy')}
                                        className={`pb-2 border-b-2 transition-colors ${activeTab === 'privacy' ? 'border-white text-white' : 'border-transparent text-gray-500 hover:text-white'}`}
                                    >
                                        Privacy Policy
                                    </button>
                                </div>
                            </div>

                            {/* Scrollable Content */}
                            <div className="overflow-y-auto p-8 md:p-12 text-gray-300 leading-relaxed font-light text-sm">
                                {activeTab === 'terms' ? (
                                    <div className="space-y-6">
                                        <div>
                                            <h3 className="text-white font-bold mb-2 flex items-center gap-2">
                                                <FileText className="w-4 h-4" /> 1. Acceptance of Terms
                                            </h3>
                                            <p>
                                                By accessing DevApp, you agree to be bound by these Terms of Service. This platform provides a marketplace for engineering tasks (&quot;Drops&quot;). We act as the escrow agent and verification layer.
                                            </p>
                                        </div>
                                        <div>
                                            <h3 className="text-white font-bold mb-2 flex items-center gap-2">
                                                <FileText className="w-4 h-4" /> 2. Intellectual Property
                                            </h3>
                                            <p>
                                                Upon payment release, all rights, title, and interest in the submitted code transfer automatically to the Startup (Client). The Developer retains no ownership of the delivered work product.
                                            </p>
                                        </div>
                                        <div>
                                            <h3 className="text-white font-bold mb-2 flex items-center gap-2">
                                                <FileText className="w-4 h-4" /> 3. Payment & Escrow
                                            </h3>
                                            <p>
                                                Funds are held in escrow until the Code is merged. Merging a Pull Request constitutes acceptance of the work and triggers immediate release of funds. This action is irreversible.
                                            </p>
                                        </div>
                                    </div>
                                ) : (
                                    <div className="space-y-6">
                                        <div>
                                            <h3 className="text-white font-bold mb-2 flex items-center gap-2">
                                                <Lock className="w-4 h-4" /> 1. Data Collection
                                            </h3>
                                            <p>
                                                We collect minimal data required for authentication and payment processing (GitHub ID, Email, Wallet Address). We do not sell your personal data.
                                            </p>
                                        </div>
                                        <div>
                                            <h3 className="text-white font-bold mb-2 flex items-center gap-2">
                                                <Lock className="w-4 h-4" /> 2. Code Security
                                            </h3>
                                            <p>
                                                Source code cloned from Startups is subject to strict confidentiality. Developers are prohibited from sharing, publishing, or reusing proprietary code accessed via the platform.
                                            </p>
                                        </div>
                                    </div>
                                )}

                                <div className="mt-12 pt-8 border-t border-white/10 text-center">
                                    <p className="text-xs text-gray-500 mb-4">Last Updated: February 2026</p>
                                    <button
                                        onClick={onClose}
                                        className="bg-white text-black px-8 py-3 font-bold uppercase tracking-widest text-xs hover:bg-gray-200 transition-colors"
                                    >
                                        I Understand
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
