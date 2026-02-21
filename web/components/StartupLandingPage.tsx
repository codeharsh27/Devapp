"use client";

import { motion } from "framer-motion";
import { Code2, GitBranch, CheckCircle2, AlertTriangle, ChevronDown, ChevronUp, Briefcase, Zap, Timer, Award, Sparkles } from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import { supabase } from "@/lib/supabaseClient";
import ManifestoModal from "./ManifestoModal";
import ProtocolModal from "./ProtocolModal";
import LegalModal from "./LegalModal";

// --- Components ---

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
                <div className="hidden md:flex items-center gap-10">
                    <Link href="#hiring" className="text-xs font-semibold uppercase tracking-widest text-gray-400 hover:text-white transition-colors">Hiring Model</Link>
                    <Link href="#drops" className="text-xs font-semibold uppercase tracking-widest text-gray-400 hover:text-white transition-colors">Drops</Link>
                    <Link href="/pricing" className="text-xs font-semibold uppercase tracking-widest text-gray-400 hover:text-white transition-colors">Pricing</Link>
                </div>
                <div className="flex items-center gap-4">
                    <Link href="/" className="hidden md:block px-6 py-2 text-gray-400 text-xs font-bold uppercase tracking-widest hover:text-white transition-colors">
                        For Developers
                    </Link>
                    <Link href="/startup/dashboard/login?view=signup&role=startup" className="px-6 py-2 bg-white text-black text-xs font-bold uppercase tracking-widest hover:bg-gray-200 transition-colors">
                        Start Delegating
                    </Link>
                </div>
            </div>
        </nav>
    );
}

function Hero() {
    return (
        <section className="min-h-screen pt-40 flex flex-col justify-start relative bg-black text-white">
            <div className="absolute inset-0 bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px] pointer-events-none"></div>

            <div className="flex-none flex flex-col items-center text-center w-full mb-12 max-w-[1400px] mx-auto px-6 z-10 relative">
                <FadeIn>
                    <div className="flex items-center justify-center gap-2 mb-6">
                        <div className="h-px w-8 bg-white" />
                        <span className="text-xs font-bold uppercase tracking-widest text-white">Elastic Engineering Network</span>
                        <div className="h-px w-8 bg-white" />
                    </div>

                    <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-500/10 border border-indigo-500/20 text-indigo-400 text-[10px] uppercase font-bold tracking-widest mb-6">
                        <Sparkles className="w-3 h-3" /> Founding Partner Cohort: $0 Fees
                    </div>

                    <h1 className="text-5xl md:text-7xl font-bold tracking-tighter text-white mb-6 leading-[0.9]">
                        STOP BURNING OUT<br />
                        <span className="text-gray-500">YOUR TEAM.</span>
                    </h1>
                    <p className="text-lg text-gray-400 max-w-2xl mx-auto leading-relaxed mb-8 font-light">
                        Delegate individual tickets to verified senior engineers. Merge PRs, not resumes.
                        Ship features faster without hiring more full-time staff.
                    </p>

                    <div className="flex flex-col md:flex-row gap-4 justify-center">
                        <Link href="/startup/dashboard/login?view=signup&role=startup" className="h-14 px-8 bg-white text-black text-xs font-bold uppercase tracking-widest hover:bg-gray-200 transition-colors flex items-center justify-center">
                            Post First Drop
                        </Link>
                        <Link href="#drops" className="h-14 px-8 border border-white/20 text-white text-xs font-bold uppercase tracking-widest hover:bg-white/10 transition-colors flex items-center justify-center">
                            View Open Missions
                        </Link>
                    </div>
                </FadeIn>
            </div>

            {/* Dashboard Preview */}
            <div className="w-full px-4 md:px-[5%] relative z-0 flex-1 flex flex-col justify-end mt-12">
                <FadeIn delay={0.2}>
                    <div className="relative w-full max-w-6xl mx-auto bg-[#111] rounded-t-xl border border-white/10 shadow-2xl overflow-hidden min-h-[500px]">
                        {/* Fake Browser Top Bar */}
                        <div className="h-10 bg-[#1A1A1A] border-b border-white/10 flex items-center px-4 gap-2">
                            <div className="w-3 h-3 rounded-full bg-red-500/20 border border-red-500/50"></div>
                            <div className="w-3 h-3 rounded-full bg-yellow-500/20 border border-yellow-500/50"></div>
                            <div className="w-3 h-3 rounded-full bg-green-500/20 border border-green-500/50"></div>
                            <div className="ml-4 text-[10px] font-mono text-gray-500">devapp_dashboard.exe</div>
                        </div>

                        <div className="grid md:grid-cols-4 h-full min-h-[500px]">
                            {/* Sidebar */}
                            <div className="hidden md:block border-r border-white/10 p-6 space-y-6">
                                <div className="space-y-1">
                                    <div className="text-xs font-bold text-gray-500 uppercase px-2 mb-2">Team</div>
                                    <div className="text-sm bg-white/10 text-white px-2 py-1.5 rounded cursor-pointer">StartUp_Inc</div>
                                </div>
                                <div className="space-y-1">
                                    <div className="text-xs font-bold text-gray-500 uppercase px-2 mb-2">Menu</div>
                                    {['Active Drops', 'Candidates', 'Integrations', 'Billing'].map(item => (
                                        <div key={item} className="text-sm text-gray-400 hover:text-white px-2 py-1.5 cursor-pointer">{item}</div>
                                    ))}
                                </div>
                            </div>

                            {/* Main Content */}
                            <div className="col-span-3 p-8">
                                <div className="flex justify-between items-center mb-8">
                                    <h2 className="text-xl font-bold">Active Drops</h2>
                                    <button className="bg-white text-black text-[10px] font-bold uppercase px-4 py-2 rounded">
                                        + New Drop
                                    </button>
                                </div>

                                <div className="space-y-4">
                                    <div className="border border-white/10 bg-[#0A0A0A] p-4 rounded-lg flex items-center justify-between">
                                        <div>
                                            <div className="flex items-center gap-2 mb-1">
                                                <GitBranch className="w-4 h-4 text-blue-500" />
                                                <span className="font-bold text-sm">fix/stripe-webhook-timeout</span>
                                                <span className="text-[10px] bg-blue-500/20 text-blue-400 px-1.5 rounded">Backend</span>
                                            </div>
                                            <div className="text-xs text-gray-500">Posted 2h ago • 14 Submissions</div>
                                        </div>
                                        <div className="text-right">
                                            <div className="text-lg font-bold">3 Passing</div>
                                            <div className="text-[10px] text-green-500">98.5% Match</div>
                                        </div>
                                    </div>

                                    <div className="border border-white/10 bg-[#0A0A0A] p-4 rounded-lg flex items-center justify-between opacity-50">
                                        <div>
                                            <div className="flex items-center gap-2 mb-1">
                                                <Briefcase className="w-4 h-4 text-purple-500" />
                                                <span className="font-bold text-sm">feat/dashboard-virtualization</span>
                                                <span className="text-[10px] bg-purple-500/20 text-purple-400 px-1.5 rounded">Frontend</span>
                                            </div>
                                            <div className="text-xs text-gray-500">Closed yesterday • 42 Submissions</div>
                                        </div>
                                        <div className="text-right">
                                            <div className="text-lg font-bold">HIRED</div>
                                            <div className="text-[10px] text-gray-500">Alex Chen</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </FadeIn>
            </div>
        </section>
    );
}

function BenefitsSection() {
    return (
        <section className="py-32 bg-white text-black">
            <div className="max-w-[1200px] mx-auto px-6">
                <FadeIn>
                    <div className="grid md:grid-cols-3 gap-12">
                        <div className="space-y-4">
                            <div className="w-12 h-12 bg-black text-white flex items-center justify-center rounded-lg">
                                <Timer className="w-6 h-6" />
                            </div>
                            <h3 className="text-xl font-bold">Elastic Capacity</h3>
                            <p className="text-gray-600 leading-relaxed">
                                Need to ship faster? Don&apos;t hire a full-time employee for a temporary spike. Spin up our network instantly like AWS for developers.
                            </p>
                        </div>
                        <div className="space-y-4">
                            <div className="w-12 h-12 bg-black text-white flex items-center justify-center rounded-lg">
                                <Zap className="w-6 h-6" />
                            </div>
                            <h3 className="text-xl font-bold">Focus on Core IP</h3>
                            <p className="text-gray-600 leading-relaxed">
                                Let your in-house team focus on the &quot;Secret Sauce&quot;. We handle the integrations, the tech debt, and the &quot;boring&quot; but critical work.
                            </p>
                        </div>
                        <div className="space-y-4">
                            <div className="w-12 h-12 bg-black text-white flex items-center justify-center rounded-lg">
                                <Award className="w-6 h-6" />
                            </div>
                            <h3 className="text-xl font-bold">Instant Backlog Clearance</h3>
                            <p className="text-gray-600 leading-relaxed">
                                From &quot;Update Stripe API&quot; to &quot;Fix Mobile Padding&quot;. Post 10 tickets on Friday, review 10 passing PRs on Monday.
                            </p>
                        </div>
                    </div>
                </FadeIn>
            </div>
        </section>
    );
}

function DropExamples() {
    return (
        <section id="drops" className="py-32 bg-[#F5F5F7]">
            <div className="max-w-[1200px] mx-auto px-6">
                <FadeIn>
                    <div className="text-center mb-16">
                        <span className="text-xs font-bold uppercase tracking-widest text-black bg-white px-2 py-1 border border-black/5">Use Cases</span>
                        <h2 className="text-4xl font-bold tracking-tight text-black mt-4">What can you Drop?</h2>
                    </div>

                    <div className="grid md:grid-cols-3 gap-8">
                        {[
                            {
                                icon: <AlertTriangle className="w-5 h-5 text-red-500" />,
                                title: "The Backlog Crusher",
                                subtitle: "Bug Fix / Optimization",
                                example: "Fix Memory Leak in Payment Service",
                                outcome: "34 Submissions • Fixed in 4h"
                            },
                            {
                                icon: <Zap className="w-5 h-5 text-yellow-500" />,
                                title: "The Feature Sprint",
                                subtitle: "New Components / Logic",
                                example: "Implement Dark Mode in Settings",
                                outcome: "12 Submissions • Merged in 2d"
                            },
                            {
                                icon: <Briefcase className="w-5 h-5 text-purple-500" />,
                                title: "The Creative Spark",
                                subtitle: "Design / Content",
                                example: "Refresh Landing Page Hero UI",
                                outcome: "8 Designs • Winner Hired"
                            }
                        ].map((item, i) => (
                            <div key={i} className="bg-white p-8 rounded-xl border border-black/5 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden group">
                                <div className="absolute top-0 right-0 w-24 h-24 bg-gray-50 rounded-bl-full -mr-12 -mt-12 z-0 group-hover:bg-gray-100 transition-colors"></div>
                                <div className="relative z-10">
                                    <div className="w-10 h-10 bg-white border border-black/5 rounded-full flex items-center justify-center mb-6 shadow-sm">
                                        {item.icon}
                                    </div>
                                    <h3 className="text-lg font-bold text-black mb-1">{item.title}</h3>
                                    <p className="text-xs text-gray-500 font-bold uppercase tracking-widest mb-6">{item.subtitle}</p>

                                    <div className="bg-[#F5F5F7] p-4 rounded-lg font-mono text-sm text-gray-700 mb-4 border border-black/5">
                                        $ git drop &quot;{item.example}&quot;
                                    </div>

                                    <div className="flex items-center gap-2 text-xs font-bold text-green-600 bg-green-50 p-2 rounded">
                                        <CheckCircle2 className="w-3 h-3" />
                                        {item.outcome}
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>
                </FadeIn>
            </div>
        </section>
    )
}

function QuoteSection() {
    return (
        <section className="py-24 bg-[#F5F5F7] border-y border-black/5 text-black">
            <div className="max-w-[1000px] mx-auto px-6 text-center">
                <FadeIn>
                    <h2 className="text-2xl md:text-4xl font-bold leading-tight mb-8 text-black">
                        &quot;We stopped hiring resumes. We posted our memory leak issue as a Drop. A 20-year-old student fixed it in 4 hours. We hired him immediately.&quot;
                    </h2>
                    <div className="flex items-center justify-center gap-4">
                        <div className="w-10 h-10 bg-black rounded-full"></div>
                        <div className="text-left">
                            <div className="text-sm font-bold text-black">Sarah Jenkins</div>
                            <div className="text-xs text-gray-500 uppercase tracking-widest">CTO, Scaling Fintech</div>
                        </div>
                    </div>
                </FadeIn>
            </div>
        </section>
    )
}

function HiringModel() {
    return (
        <section id="hiring" className="py-32 bg-black text-white border-t border-white/10">
            <div className="max-w-[1200px] mx-auto px-6">
                <FadeIn>
                    <div className="text-center mb-24">
                        <span className="text-xs font-bold uppercase tracking-widest text-gray-400 bg-white/5 px-2 py-1 border border-white/10">The Platform</span>
                        <h2 className="text-4xl md:text-5xl font-bold tracking-tight mt-6">The Delegation Protocol.</h2>
                        <p className="text-gray-400 max-w-2xl mx-auto mt-6 leading-relaxed">
                            Startups have limited resources. Your core team should focus on architecture and core IP.
                            Delegate backlog, integrations, and optimizations to our network.
                        </p>
                    </div>

                    <div className="relative">
                        {/* Connecting Line */}
                        <div className="hidden md:block absolute top-[50px] left-0 right-0 h-px bg-gradient-to-r from-transparent via-white/20 to-transparent"></div>

                        <div className="grid md:grid-cols-4 gap-12 relative">
                            {[
                                { step: "01", title: "Define", desc: "Post a 'Drop' (Issue/Feature) directly from your issue tracker or CLI. Set the bounty." },
                                { step: "02", title: "Execute", desc: "Verified developers pick up the ticket. You sleep while they code." },
                                { step: "03", title: "Auto-Verify", desc: "Our CI engine runs your full test suite. Only passing builds reach your inbox." },
                                { step: "04", title: "Merge", desc: "You review the passing code. Merge it with one click. Payment is released." }
                            ].map((item, i) => (
                                <div key={i} className="relative bg-black group cursor-default">
                                    <div className="w-24 h-24 bg-zinc-900 border border-white/10 rounded-full flex items-center justify-center text-xl font-bold font-mono mb-8 mx-auto z-10 relative group-hover:bg-white group-hover:text-black group-hover:scale-110 transition-all duration-300 shadow-xl shadow-black">
                                        {item.step}
                                    </div>
                                    <div className="text-center">
                                        <h3 className="text-xl font-bold mb-3">{item.title}</h3>
                                        <p className="text-gray-400 text-sm leading-relaxed">{item.desc}</p>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </FadeIn>
            </div>
        </section>
    );
}

function FinalCTA() {
    const [email, setEmail] = useState("");
    const [status, setStatus] = useState<"idle" | "loading" | "success" | "error">("idle");
    const [msg, setMsg] = useState("");

    const handleJoin = async () => {
        if (!email || !email.includes("@")) return;
        setStatus("loading");

        try {
            const { error } = await supabase
                .from("waitlist")
                .insert([{ email, user_type: "startup" }]);

            if (error) {
                if (error.code === '23505') throw new Error("Email already on waitlist!");
                throw error;
            }

            setStatus("success");
            setEmail("");
        } catch (e: unknown) {
            setStatus("error");
            setMsg(e instanceof Error ? e.message : "Something went wrong");
        }
    };

    return (
        <section className="py-32 bg-black text-white text-center">
            <div className="max-w-[800px] mx-auto px-6">
                <FadeIn>
                    <h2 className="text-4xl md:text-6xl font-bold tracking-tighter mb-8">
                        Zero Fees. Infinite Scale.
                    </h2>
                    <p className="text-xl text-gray-400 mb-12">
                        Apply for the Founding Partner cohort. Pay $0 platform fees forever.
                        <br />
                        <span className="text-sm text-gray-600 mt-2 block">Limited to first 50 startups.</span>
                    </p>

                    {status === "success" ? (
                        <div className="bg-green-500/10 border border-green-500/20 p-6 rounded-lg text-green-500 inline-block">
                            <h3 className="font-bold flex items-center justify-center gap-2"><CheckCircle2 className="w-5 h-5" /> Access Requested</h3>
                            <p className="text-sm mt-2">We will contact you shortly to onboard your organization.</p>
                        </div>
                    ) : (
                        <div className="flex flex-col items-center gap-4 max-w-md mx-auto">
                            <div className="flex w-full gap-2">
                                <input
                                    type="email"
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                    placeholder="work@company.com"
                                    className="flex-1 bg-white/10 border border-white/10 text-white px-6 py-4 rounded-l-full focus:outline-none focus:border-white transition-colors"
                                    disabled={status === "loading"}
                                />
                                <button
                                    onClick={handleJoin}
                                    disabled={status === "loading" || !email}
                                    className="bg-white text-black px-8 py-4 rounded-r-full font-bold uppercase tracking-widest hover:bg-gray-200 transition-colors whitespace-nowrap disabled:opacity-50"
                                >
                                    {status === "loading" ? "..." : "Apply for Cohort"}
                                </button>
                            </div>
                            {status === "error" && (
                                <p className="text-red-500 text-sm flex items-center gap-2"><AlertTriangle className="w-4 h-4" /> {msg}</p>
                            )}
                            <p className="text-xs text-gray-500 mt-2">Limited to technical founders and engineering leads.</p>
                        </div>
                    )}
                </FadeIn>
            </div>
        </section>
    );
}

function FAQSection() {
    const [openIndex, setOpenIndex] = useState<number | null>(0);

    const questions = [
        {
            q: "What responsibilities can I delegate effectively?",
            a: "Tasks with clear acceptance criteria are ideal. This includes Backlog Bug Fixes, Integrations (Stripe, Twilio, OpenAI), Component Refactors, UI/UX Polish, and Writing Test Coverage. Tasks requiring deep, undocumented tribal knowledge of your core architecture are better kept in-house."
        },
        {
            q: "How do you ensure the code doesn't break our build?",
            a: "We enforce 'Green Build' delivery. We integrate with your CI/CD pipeline (GitHub Actions, etc.). A developer cannot submit a solution unless it passes your existing test suite. You only review code that is already verified to work."
        },
        {
            q: "Is this cheaper than a contractor?",
            a: "Significantly. Contractors charge for time (hourly/daily), regardless of output. With DevApp, you pay for the outcome (the merged PR). If the work isn&apos;t done to your satisfaction, you don&apos;t pay. Plus, our 0% Founding Partner fee means you pay literally zero overhead."
        },
        {
            q: "Who are the developers?",
            a: "Our network consists of Senior Engineers, Open Source Maintainers, and verified Top-Tier Students. We vet every developer through a rigorous coding challenge before they can touch a single Drop."
        }
    ];

    const toggle = (i: number) => {
        setOpenIndex(openIndex === i ? null : i);
    };

    return (
        <section className="py-32 bg-black border-t border-white/10">
            <div className="max-w-[800px] mx-auto px-6">
                <FadeIn>
                    <div className="text-center mb-16">
                        <h2 className="text-4xl font-bold tracking-tight text-white mb-4">Common Queries.</h2>
                        <p className="text-gray-400">Understanding the Platform interaction model.</p>
                    </div>

                    <div className="space-y-4">
                        {questions.map((item, i) => (
                            <div key={i} className="border border-white/10 rounded-lg overflow-hidden bg-[#111] hover:border-white/30 transition-colors">
                                <button
                                    onClick={() => toggle(i)}
                                    className="w-full flex items-center justify-between p-6 text-left"
                                >
                                    <h3 className="text-lg font-bold text-white flex items-center gap-3">
                                        <span className="text-gray-600 font-mono text-xs opacity-50">0{i + 1}</span>
                                        {item.q}
                                    </h3>
                                    {openIndex === i ?
                                        <ChevronUp className="w-5 h-5 text-white" /> :
                                        <ChevronDown className="w-5 h-5 text-gray-500" />
                                    }
                                </button>

                                {openIndex === i && (
                                    <motion.div
                                        initial={{ height: 0, opacity: 0 }}
                                        animate={{ height: "auto", opacity: 1 }}
                                        exit={{ height: 0, opacity: 0 }}
                                        transition={{ duration: 0.3 }}
                                        className="px-6 pb-6"
                                    >
                                        <p className="text-gray-400 leading-relaxed border-t border-white/5 pt-4">
                                            {item.a}
                                        </p>
                                    </motion.div>
                                )}
                            </div>
                        ))}
                    </div>
                </FadeIn>
            </div>
        </section>
    );
}


function Footer({ onOpenManifesto, onOpenProtocol, onOpenLegal }: { onOpenManifesto: () => void, onOpenProtocol: () => void, onOpenLegal: () => void }) {
    return (
        <footer className="bg-black text-white py-12 border-t border-white/10">
            <div className="max-w-[1200px] mx-auto px-6 flex flex-col md:flex-row justify-between items-center text-xs text-gray-500 font-mono uppercase tracking-widest">
                <div className="flex items-center gap-2 mb-4 md:mb-0">
                    <div className="w-4 h-4 bg-white flex items-center justify-center">
                        <Code2 className="w-2 h-2 text-black" />
                    </div>
                    <span>DevApp_Inc. System v1.0.4</span>
                </div>

                <div className="flex gap-8">
                    <button onClick={onOpenManifesto} className="hover:text-white transition-colors uppercase tracking-widest">Manifesto</button>
                    <button onClick={onOpenProtocol} className="hover:text-white transition-colors uppercase tracking-widest">Protocol</button>
                    <button onClick={onOpenLegal} className="hover:text-white transition-colors uppercase tracking-widest">Legal</button>
                </div>
            </div>
        </footer>
    );
}

export default function StartupLandingPage() {
    const [isManifestoOpen, setIsManifestoOpen] = useState(false);
    const [isProtocolOpen, setIsProtocolOpen] = useState(false);
    const [isLegalOpen, setIsLegalOpen] = useState(false);

    return (
        <div className="min-h-screen bg-white text-black font-sans selection:bg-black selection:text-white overflow-x-hidden">
            <Navbar />
            <Hero />
            <BenefitsSection />
            <DropExamples />
            <QuoteSection />
            <HiringModel />
            <FinalCTA />
            <FAQSection />
            <Footer
                onOpenManifesto={() => setIsManifestoOpen(true)}
                onOpenProtocol={() => setIsProtocolOpen(true)}
                onOpenLegal={() => setIsLegalOpen(true)}
            />
            <ManifestoModal isOpen={isManifestoOpen} onClose={() => setIsManifestoOpen(false)} />
            <ProtocolModal isOpen={isProtocolOpen} onClose={() => setIsProtocolOpen(false)} />
            <LegalModal isOpen={isLegalOpen} onClose={() => setIsLegalOpen(false)} />
        </div>
    );
}
