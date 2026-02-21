"use client";

import { motion, AnimatePresence } from "framer-motion";
import { X, Terminal } from "lucide-react";
import { useEffect } from "react";

export default function ManifestoModal({ isOpen, onClose }: { isOpen: boolean, onClose: () => void }) {
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
                                    <Terminal className="w-4 h-4 text-green-500" />
                                    <span>manifesto.md</span>
                                </div>
                                <button onClick={onClose} className="text-gray-500 hover:text-white transition-colors">
                                    <X className="w-5 h-5" />
                                </button>
                            </div>

                            {/* Scrollable Content */}
                            <div className="overflow-y-auto p-8 md:p-12 space-y-8 text-gray-300 leading-relaxed font-light">
                                <div>
                                    <h2 className="text-3xl text-white font-bold mb-4 tracking-tighter">The Resume is Dead.</h2>
                                    <p>
                                        We are entering an era where AI writes 80% of the boilerplate code. In this world, a resume listing &quot;React Expert&quot; is meaningless. Anyone can prompt &quot;Create a React Component.&quot;
                                    </p>
                                </div>

                                <div>
                                    <h3 className="text-xl text-white font-bold mb-2">The New Currency is Execution.</h3>
                                    <p>
                                        Hiring is broken because it relies on *claims* (resumes) instead of *proof* (commits).
                                        We believe the only way to hire an engineer is to see how they debug a localized failure in a distributed system.
                                    </p>
                                </div>

                                <div>
                                    <h3 className="text-xl text-white font-bold mb-2">For the Vanguard.</h3>
                                    <p>
                                        DevApp is not a job board. It is a proving ground. We provide the &quot;Scar Tissue&quot; that bootcamps can&apos;t teach.
                                        We simulate the chaos of production—deadlocks, race conditions, legacy refactors—so that when you deploy on Day 1, you don&apos;t flinch.
                                    </p>
                                </div>

                                <div className="pt-8 border-t border-white/10 text-center">
                                    <p className="font-mono text-xs text-green-500 mb-2">root@devapp:~$ ./sign_manifesto.sh</p>
                                    <button
                                        onClick={onClose}
                                        className="bg-white text-black px-8 py-3 font-bold uppercase tracking-widest text-xs hover:bg-gray-200 transition-colors"
                                    >
                                        Acknowledge & Close
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
