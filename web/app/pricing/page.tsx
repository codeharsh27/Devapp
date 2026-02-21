"use client";

import { motion } from "framer-motion";
import { CheckCircle2, Zap, ArrowRight, Code2 } from "lucide-react";
import Link from "next/link";
import { useState } from "react";

const FadeIn = ({ children, delay = 0, className = "" }: { children: React.ReactNode, delay?: number, className?: string }) => (
    <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, margin: "-50px" }}
        transition={{ duration: 0.7, delay, ease: "easeOut" }}
        className={className}
    >
        {children}
    </motion.div>
);

function Navbar() {
    return (
        <nav className="fixed top-0 w-full z-50 bg-black/95 backdrop-blur-sm border-b border-white/10 text-white">
            <div className="max-w-[1400px] mx-auto px-6 h-20 flex items-center justify-between">
                <Link href="/" className="flex items-center gap-3 group">
                    <div className="w-8 h-8 bg-white flex items-center justify-center">
                        <Code2 className="w-4 h-4 text-black" />
                    </div>
                    <span className="font-bold text-lg tracking-tight text-white uppercase">DevApp_Inc.</span>
                </Link>
                <div className="flex items-center gap-4">
                    <Link href="/startups" className="hidden md:block px-6 py-2 text-gray-400 text-xs font-bold uppercase tracking-widest hover:text-white transition-colors">
                        Back to Overview
                    </Link>
                    <Link href="/login" className="px-6 py-2 bg-white text-black text-xs font-bold uppercase tracking-widest hover:bg-gray-200 transition-colors">
                        Start Hiring
                    </Link>
                </div>
            </div>
        </nav>
    );
}

export default function PricingPage() {

    return (
        <div className="min-h-screen bg-[#F5F5F7] text-black font-sans selection:bg-black selection:text-white pt-24">
            <Navbar />

            <section className="py-24">
                <div className="max-w-[1200px] mx-auto px-6">
                    <FadeIn>
                        <div className="text-center mb-16">
                            <h1 className="text-5xl md:text-7xl font-bold tracking-tighter mb-6">
                                Transparent Pricing.
                            </h1>
                            <p className="text-xl text-gray-600 max-w-2xl mx-auto leading-relaxed">
                                No hidden fees. No long-term contracts. Pay for outcomes, not hours.
                            </p>
                        </div>

                        <div className="max-w-4xl mx-auto">
                            <div className="bg-black text-white p-12 rounded-3xl border border-white/10 shadow-2xl relative overflow-hidden">
                                <div className="absolute top-0 right-0 bg-white text-black text-xs font-bold uppercase px-6 py-2 rounded-bl-2xl z-10">Limited Time Offer</div>

                                {/* Background Effects */}
                                <div className="absolute top-0 left-0 w-full h-full overflow-hidden opacity-20 pointer-events-none">
                                    <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-blue-500/30 blur-[100px] rounded-full translate-x-1/2 -translate-y-1/2"></div>
                                    <div className="absolute bottom-0 left-0 w-[300px] h-[300px] bg-purple-500/30 blur-[100px] rounded-full -translate-x-1/2 translate-y-1/2"></div>
                                </div>

                                <div className="relative z-10 grid md:grid-cols-2 gap-12 items-center">
                                    <div className="relative z-10">
                                        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-green-500/10 border border-green-500/20 text-green-400 text-[10px] font-bold uppercase tracking-widest mb-6">
                                            <div className="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse"></div>
                                            Founding Partner Program
                                        </div>
                                        <h2 className="text-5xl md:text-6xl font-bold mb-6 tracking-tight">
                                            <span className="text-gray-500">PAY</span> 0% FEES.
                                        </h2>
                                        <p className="text-lg text-gray-400 mb-8 leading-relaxed font-light">
                                            We are building the network of the future. Join the first cohort and never pay platform fees again.
                                            You only pay the <span className="text-white font-bold">100% bounty</span> to the developer.
                                        </p>

                                        <div className="flex flex-col gap-5">
                                            {[
                                                "Lifetime 0% Commission (First 50 Only)",
                                                "Priority Matching (Top 1% Network)",
                                                "Direct Founder Support Channel"
                                            ].map((feat, i) => (
                                                <div key={i} className="flex items-center gap-4 group">
                                                    <div className="w-8 h-8 rounded-full bg-white/5 border border-white/10 flex items-center justify-center group-hover:bg-green-500/20 group-hover:border-green-500/50 transition-colors">
                                                        <CheckCircle2 className="w-4 h-4 text-green-500" />
                                                    </div>
                                                    <span className="font-medium text-gray-300 group-hover:text-white transition-colors">{feat}</span>
                                                </div>
                                            ))}
                                        </div>
                                    </div>

                                    <div className="relative">
                                        <div className="absolute inset-0 bg-gradient-to-tr from-green-500/20 to-blue-500/20 blur-3xl opacity-30 rounded-full"></div>
                                        <div className="bg-white/5 backdrop-blur-xl p-8 rounded-2xl border border-white/10 text-center relative z-10 hover:border-white/20 transition-all duration-500 hover:transform hover:scale-[1.02] hover:shadow-2xl">
                                            <div className="text-xs text-gray-500 uppercase tracking-widest mb-4">Standard Platform Fee</div>
                                            <div className="text-2xl font-bold line-through text-gray-600 mb-8 decoration-red-500/50">$49 / drop</div>

                                            <div className="w-full h-px bg-gradient-to-r from-transparent via-white/10 to-transparent mb-8"></div>

                                            <div className="text-xs text-green-400 font-bold uppercase tracking-widest mb-2">Partner Price</div>
                                            <div className="text-7xl font-bold mb-2 tracking-tighter text-white drop-shadow-lg">$0</div>
                                            <div className="text-sm text-gray-400 mb-8">Forever.</div>

                                            <Link href="/startups" className="w-full block py-4 bg-white text-black font-bold uppercase text-xs tracking-widest hover:bg-gray-200 transition-all transform hover:-translate-y-0.5 rounded-lg shadow-lg hover:shadow-white/20">
                                                Become a Partner
                                            </Link>
                                            <p className="text-[10px] text-gray-500 mt-4">
                                                * 32 / 50 spots remaining in Cohort 1.
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Delegated Engineering Explanation */}
                        <div className="mt-32 max-w-4xl mx-auto text-center border-t border-black/10 pt-24">
                            <h2 className="text-3xl font-bold mb-8">Elastic Delegation.</h2>
                            <p className="text-lg text-gray-600 mb-12">
                                Stop burning out your core team on maintenance. Delegate tech debt, integrations, and optimizations to the network.
                                Keep your in-house team focused on your product&apos;s &quot;Secret Sauce&quot;.
                            </p>

                            <div className="grid md:grid-cols-2 gap-8 text-left bg-white p-8 rounded-2xl border border-black/5">
                                <div>
                                    <h3 className="font-bold text-lg mb-2 flex items-center gap-2">
                                        <Zap className="w-5 h-5 text-yellow-500" /> Core Team Focus
                                    </h3>
                                    <p className="text-sm text-gray-500">
                                        Your CTO handles architecture. We handle the backlog.
                                    </p>
                                </div>
                                <div>
                                    <h3 className="font-bold text-lg mb-2 flex items-center gap-2">
                                        <ArrowRight className="w-5 h-5 text-green-500" /> Speed to Market
                                    </h3>
                                    <p className="text-sm text-gray-500">
                                        Parallelize development. Fix 10 bugs in one night instead of one week.
                                    </p>
                                </div>
                            </div>
                        </div>

                    </FadeIn>
                </div>
            </section>
        </div>
    );
}
