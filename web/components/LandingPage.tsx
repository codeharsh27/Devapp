"use client";

import { motion } from "framer-motion";
import { Code2, GitBranch, Terminal, ArrowRight, CheckCircle2, Users, Cpu, AlertTriangle, ChevronDown, ChevronUp } from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import ManifestoModal from "./ManifestoModal";
import ProtocolModal from "./ProtocolModal";
import LegalModal from "./LegalModal";
import SmartAuthLink from "./SmartAuthLink";

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
        <nav className="fixed top-0 w-full z-50 bg-[#F5F5F7]/80 backdrop-blur-sm border-b border-black/5">
            <div className="max-w-[1400px] mx-auto px-6 h-20 flex items-center justify-between">
                <Link href="/" className="flex items-center gap-3 group">
                    <div className="w-8 h-8 bg-black flex items-center justify-center">
                        <Code2 className="w-4 h-4 text-white" />
                    </div>
                    <span className="font-bold text-lg tracking-tight text-black uppercase">DevApp_Inc.</span>
                </Link>
                <div className="hidden md:flex items-center gap-10">
                    <Link href="#missions" className="text-xs font-semibold uppercase tracking-widest text-gray-500 hover:text-black transition-colors">Missions</Link>
                    <Link href="#missions" className="text-xs font-semibold uppercase tracking-widest text-gray-500 hover:text-black transition-colors">Missions</Link>
                    <Link href="#faq" className="text-xs font-semibold uppercase tracking-widest text-gray-500 hover:text-black transition-colors">FAQ</Link>
                </div>
                <div className="flex items-center gap-4">
                    <Link href="/startup" className="hidden md:block px-6 py-2 text-gray-500 text-xs font-bold uppercase tracking-widest hover:text-black transition-colors">
                        For Startups
                    </Link>
                    <SmartAuthLink role="talent" loggedInHref="/talent/dashboard" guestHref="/auth?view=signup&role=talent" className="px-6 py-2 border border-black text-black text-xs font-bold uppercase tracking-widest hover:bg-black hover:text-white transition-colors">
                        Join as Developer
                    </SmartAuthLink>
                </div>
            </div>
        </nav>
    );
}

function Hero() {
    return (
        <section className="min-h-screen pt-52 flex flex-col justify-start overflow-hidden relative bg-[#F5F5F7]">
            <div className="flex-none flex flex-col items-center text-center w-full mb-12 max-w-[1400px] mx-auto px-6 z-10 relative">
                <FadeIn>
                    <div className="flex items-center justify-center gap-2 mb-6">
                        <div className="h-px w-8 bg-black" />
                        <span className="text-xs font-bold uppercase tracking-widest text-black">The New Standard for Hiring</span>
                        <div className="h-px w-8 bg-black" />
                    </div>

                    <h1 className="text-5xl md:text-8xl font-bold tracking-tighter text-black mb-6 leading-[0.9]">
                        REAL WORK.<br />
                        REAL MONEY.<br />
                        GET VERIFIED.
                    </h1>
                    <p className="text-lg text-gray-600 max-w-xl mx-auto leading-relaxed mb-8">
                        Stop leetcoding. Start shipping. Merge real engineering tickets from top startups. Get paid instantly and build an on-chain reputation that proves your seniority.
                    </p>

                    <div className="flex flex-col md:flex-row gap-4 justify-center mt-8">
                        <SmartAuthLink role="talent" loggedInHref="/talent/dashboard" guestHref="/auth?view=signup&role=talent" className="h-12 px-8 bg-black text-white text-xs font-bold uppercase tracking-widest hover:bg-gray-800 transition-colors flex items-center justify-center">
                            Join as Developer
                        </SmartAuthLink>
                        <Link href="/startup" className="h-12 px-8 border border-black text-black text-xs font-bold uppercase tracking-widest hover:bg-black hover:text-white transition-colors flex items-center justify-center">
                            For Startups
                        </Link>
                    </div>
                </FadeIn>
            </div>



            <div className="w-full px-4 md:px-[5%] relative z-0 flex-1 flex flex-col justify-end">
                <FadeIn delay={0.2}>
                    <DeveloperDashboardPreview />
                </FadeIn>
            </div>
        </section>
    );
}

function DeveloperDashboardPreview() {
    return (

        <div className="relative w-full max-w-6xl mx-auto bg-[#0A0A0A] rounded-t-xl border border-white/10 shadow-2xl overflow-hidden min-h-[400px] font-mono text-sm translate-y-4">
            {/* Fake Browser Top Bar */}
            <div className="h-10 bg-[#141414] border-b border-white/10 flex items-center px-4 gap-2">
                <div className="w-3 h-3 rounded-full bg-red-500/20 border border-red-500/50"></div>
                <div className="w-3 h-3 rounded-full bg-yellow-500/20 border border-yellow-500/50"></div>
                <div className="w-3 h-3 rounded-full bg-green-500/20 border border-green-500/50"></div>
                <div className="ml-4 text-[10px] text-gray-500 flex items-center gap-2">
                    <Terminal className="w-3 h-3" />
                    dev_workspace_v2.exe
                </div>
            </div>

            <div className="grid md:grid-cols-4 h-full min-h-[400px]">
                {/* Sidebar */}
                <div className="hidden md:block border-r border-white/10 p-4 space-y-6 bg-[#0F0F0F]">
                    <div className="flex items-center gap-3 px-2 mb-8">
                        <div className="w-8 h-8 rounded bg-gradient-to-br from-blue-600 to-purple-600"></div>
                        <div>
                            <div className="font-bold text-gray-200">Alex_Dev</div>
                            <div className="text-[10px] text-gray-500">Lvl 42 • Elite</div>
                        </div>
                    </div>

                    <div className="space-y-1">
                        <div className="text-[10px] font-bold text-gray-600 uppercase px-2 mb-2">Navigation</div>
                        {['Dashboard', 'Find Missions', 'My Submissions', 'Earnings'].map(item => (
                            <div key={item} className={`px-3 py-2 rounded cursor-pointer transition-colors ${item === 'Dashboard' ? 'bg-white/5 text-white' : 'text-gray-500 hover:text-gray-300'}`}>
                                {item}
                            </div>
                        ))}
                    </div>
                </div>

                {/* Main Content */}
                {/* Main Content */}
                <div className="col-span-3 p-6 bg-[#0A0A0A] text-gray-300">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="text-xl font-bold text-white">Current Mission</h2>
                        <span className="text-xs bg-green-500/10 text-green-500 px-3 py-1 rounded border border-green-500/20 animate-pulse">● Active</span>
                    </div>

                    {/* Active Mission Card */}
                    <div className="border border-white/10 bg-[#111] rounded-lg overflow-hidden mb-0">
                        <div className="p-6 border-b border-white/10">
                            <div className="flex justify-between items-start mb-4">
                                <div>
                                    <div className="text-[10px] text-blue-400 font-bold uppercase tracking-widest mb-1">Backend • High Priority</div>
                                    <h3 className="text-lg font-bold text-white">Optimize Postgres Query for Analytics</h3>
                                </div>
                                <div className="text-right">
                                    <div className="text-xl font-bold text-white">$450.00</div>
                                    <div className="text-[10px] text-gray-500">Reward</div>
                                </div>
                            </div>
                            <p className="text-gray-500 text-xs leading-relaxed mb-4">
                                The analytics aggregation query is timing out on large datasets. Refactor to use materialized views or optimize the join logic.
                            </p>
                            <div className="flex gap-4 text-[10px] font-mono">
                                <span className="bg-white/5 px-2 py-1 rounded text-gray-400">Time Left: 4h 12m</span>
                                <span className="bg-white/5 px-2 py-1 rounded text-gray-400">Tests: 0/14 Passing</span>
                            </div>
                        </div>
                        {/* Fake Code Editor */}
                        <div className="bg-[#050505] p-4 font-mono text-xs overflow-hidden">
                            <div className="flex gap-4 text-gray-600 mb-2 border-b border-white/5 pb-2">
                                <span className="text-white border-b border-blue-500">AnalyticsService.ts</span>
                                <span>tests/benchmark.ts</span>
                            </div>
                            <div className="space-y-1">
                                <div className="text-gray-500"><span className="text-purple-400">async function</span> <span className="text-blue-400">getDailyStats</span>(userId: string) &#123;</div>
                                <div className="text-gray-500 pl-4"><span className="text-gray-600">{"// TODO: Optimize this aggregation"}</span></div>
                                <div className="text-gray-500 pl-4"><span className="text-purple-400">const</span> result = <span className="text-purple-400">await</span> db.query(`</div>
                                <div className="text-green-400 pl-8">SELECT date_trunc(&apos;day&apos;, created_at) as day,</div>
                                <div className="text-green-400 pl-8">COUNT(*) as total_events</div>
                                <div className="text-green-400 pl-8">FROM events</div>
                                <div className="text-green-400 pl-8">WHERE user_id = $1</div>
                                <div className="text-green-400 pl-8">GROUP BY 1</div>
                                <div className="text-gray-500 pl-4">`);</div>
                                <div className="text-gray-500 pl-4"><span className="text-purple-400">return</span> result.rows;</div>
                                <div className="text-gray-500">&#125;</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}


function MissionBoard() {
    return (
        <section id="missions" className="py-32 bg-white">
            <div className="max-w-[1200px] mx-auto px-6">
                <FadeIn>
                    <div className="flex items-end justify-between mb-12 border-b border-black/10 pb-6">
                        <div>
                            <span className="text-xs font-bold uppercase tracking-widest text-black bg-gray-100 px-2 py-1">Live Operations</span>
                            <h2 className="text-4xl font-bold tracking-tight text-black mt-4">Active Missions</h2>
                        </div>
                        <div className="text-right hidden md:block">
                            <div className="text-xs font-mono text-gray-500">
                                SYSTEM_STATUS: <span className="text-green-600">ONLINE</span><br />
                                ACTIVE_DEVS: 15,421
                            </div>
                        </div>
                    </div>

                    <div className="space-y-4 font-mono text-sm">
                        {[
                            { id: "T-8024", type: "BACKEND", severity: "HIGH", status: "HOT", title: "Migrate User Auth to Supabase (Zero Downtime)", reward: "$500 + 1200XP" },
                            { id: "T-8025", type: "SYSTEMS", severity: "CRITICAL", status: "URGENT", title: "Fix Race Condition in Payment Webhook", reward: "$850 + 2000XP" },
                            { id: "T-8026", type: "FRONTEND", severity: "MEDIUM", status: "NEW", title: "Implement Virtualized List for Dashboard (10k items)", reward: "$300 + 800XP" },
                            { id: "T-8027", type: "DEVOPS", severity: "HIGH", status: "OPEN", title: "Containerize Microservices with Docker Compose", reward: "$600 + 1500XP" },
                        ].map((mission, i) => (
                            <div key={i} className="group border border-black/10 p-6 hover:bg-black hover:text-white transition-colors cursor-pointer flex flex-col md:flex-row md:items-center justify-between gap-4 relative overflow-hidden">
                                {mission.status && (
                                    <div className={`absolute top-0 right-0 text-[9px] font-bold px-2 py-1 uppercase tracking-widest ${mission.status === 'URGENT' ? 'bg-red-500 text-white' :
                                        mission.status === 'HOT' ? 'bg-orange-500 text-white' :
                                            'bg-green-500 text-white'
                                        }`}>
                                        {mission.status}
                                    </div>
                                )}
                                <div className="flex items-center gap-6">
                                    <span className="text-gray-400 group-hover:text-gray-500">#{mission.id}</span>
                                    <span className={`text-[10px] font-bold px-2 py-0.5 border ${mission.severity === 'CRITICAL' ? 'border-red-500 text-red-600' : 'border-gray-300 text-gray-500'} group-hover:border-white group-hover:text-white`}>
                                        {mission.severity}
                                    </span>
                                    <span className="font-bold text-lg">{mission.title}</span>
                                </div>
                                <div className="flex items-center gap-4">
                                    <span className="text-xs uppercase tracking-widest">{mission.reward}</span>
                                    <ArrowRight className="w-4 h-4 opacity-0 group-hover:opacity-100 transition-opacity" />
                                </div>
                            </div>
                        ))}
                    </div>

                    <div className="mt-8 text-center">
                        <div className="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-widest text-gray-500">
                            + 138 Additional Missions (Access Restricted to Verified Nodes)
                        </div>
                    </div>
                </FadeIn>
            </div>
        </section>
    );
}

// REMOVED ProtocolPhilosophy Function


// REMOVED ProtocolPhilosophy Function


function ProtocolSteps() {
    return (
        <section className="py-32 bg-[#F5F5F7] border-t border-black/5">
            <div className="max-w-[1200px] mx-auto px-6">
                <FadeIn>
                    <div className="grid md:grid-cols-2 gap-24">
                        <div>
                            <h2 className="text-4xl font-bold tracking-tight text-black mb-8">
                                How it Works.
                            </h2>
                            <p className="text-lg text-gray-600 leading-relaxed mb-12 font-light">
                                Unlike traditional hiring platforms, DevApp operates as a merit-based network.
                                Your code is the only currency that matters.
                            </p>

                            <div className="space-y-12 border-l border-black/10 pl-12 relative">
                                {[
                                    { title: "Initialization", desc: "Select a mission from the global queue. Clone the repository to your local machine." },
                                    { title: "Execution", desc: "Solve the engineering challenge. No tutorials, no hand-holding. Pure problem solving." },
                                    { title: "Verification", desc: "Push your commit. Our CI/CD pipeline runs unit tests, integration benchmarks, and security audits." },
                                    { title: "Profile Update", desc: "Successful builds are instantly verified. Your profile reputation score updates automatically." }
                                ].map((step, i) => (
                                    <div key={i} className="relative">
                                        <div className="absolute -left-[54px] top-1 w-3 h-3 bg-black rounded-full ring-4 ring-[#F5F5F7]" />
                                        <h3 className="text-lg font-bold text-black mb-2">{step.title}</h3>
                                        <p className="text-sm text-gray-500 leading-relaxed max-w-sm">{step.desc}</p>
                                    </div>
                                ))}
                            </div>
                        </div>

                        <div className="relative flex items-center justify-center">
                            {/* Visual representation of a successful build/check */}
                            <div className="flex flex-col items-center gap-6 w-full max-w-md">
                                <div className="w-full bg-white border border-black/10 shadow-2xl p-8 rounded-lg">
                                    <div className="flex items-center justify-between mb-8 border-b border-black/5 pb-4">
                                        <div className="flex items-center gap-2">
                                            <GitBranch className="w-4 h-4 text-gray-400" />
                                            <span className="font-mono text-sm font-bold">fix/payment-race-condition</span>
                                        </div>
                                        <span className="text-xs bg-green-100 text-green-700 px-2 py-0.5 font-bold uppercase tracking-wider rounded">Merged</span>
                                    </div>

                                    <div className="space-y-3 font-mono text-xs">
                                        <div className="flex justify-between text-gray-500">
                                            <span>Build Status</span>
                                            <span className="text-black font-bold">PASS</span>
                                        </div>
                                        <div className="flex justify-between text-gray-500">
                                            <span>Unit Tests</span>
                                            <span className="text-green-600">42/42 PASS</span>
                                        </div>
                                        <div className="flex justify-between text-gray-500">
                                            <span>Performance</span>
                                            <span className="text-green-600">98ms (Top 5%)</span>
                                        </div>
                                        <div className="flex justify-between text-gray-500">
                                            <span>Security Scan</span>
                                            <span className="text-green-600">0 Vulns</span>
                                        </div>
                                    </div>

                                    <div className="mt-8 pt-6 border-t border-black/5 text-center">
                                        <div className="text-[10px] uppercase tracking-widest text-gray-400 mb-1">Reputation Awarded</div>
                                        <div className="text-3xl font-bold text-black">+2,400 XP</div>
                                    </div>
                                </div>

                                <SmartAuthLink role="talent" loggedInHref="/talent/dashboard" guestHref="/auth?role=talent" className="w-full py-4 bg-black text-white font-bold uppercase text-center tracking-widest hover:bg-gray-800 transition-colors shadow-xl rounded hover:-translate-y-1 transform duration-200">
                                    Start Earning XP
                                </SmartAuthLink>
                            </div>
                        </div>
                    </div>
                </FadeIn>
            </div>
        </section>
    );
}

function FAQ() {
    const [openIndex, setOpenIndex] = useState<number | null>(0);

    const questions = [
        {
            q: "How does the verification process work?",
            a: "You clone a real repo, fix a real issue (e.g., a race condition or memory leak), and submit a PR. Our CI runs a rigorous test suite. If it passes, you earn XP and Reputation in that specific stack (e.g., \"Level 5 Backend\"). This reputation is immutable and visible to hiring startups."
        },
        {
            q: "Is this paid work?",
            a: "Yes. Many Drops are \"Bountied Issues\" from our partner startups. If your PR is the one merged, the smart contract releases the bounty to your wallet immediately. Even for non-paid practice missions, you earn Reputation, which is the key to unlocking higher-paid work."
        },
        {
            q: "Can I use AI tools (Cursor, Copilot, etc)?",
            a: "Absolutely. The modern engineer is an orchestrator of AI, not just a typist. We test for the correct outcome (efficient, bug-free code), not how you wrote it. However, our tasks are complex enough that \"blind prompting\" will almost certainly fail the edge-case tests."
        },
        {
            q: "Who are the startups hiring here?",
            a: "We partner with YC-backed and high-growth startups who don't have time for 5-round interviews. They trust our \"Proof-of-Execution\" protocol. When you reach \"Elite\" status on our platform, you skip the queue and often go straight to a final culture fit chat."
        },
        {
            q: "Is this for beginners?",
            a: "DevApp is a meritocracy. We don't care about your degree or years of experience, only your code. That said, the missions are simulated production environments. They are hard. If you can fix them, you deserve to be hired, regardless of your \"level\"."
        }
    ];

    const toggle = (i: number) => {
        setOpenIndex(openIndex === i ? null : i);
    };

    return (
        <section id="faq" className="py-32 bg-white">
            <div className="max-w-[800px] mx-auto px-6">
                <FadeIn>
                    <div className="text-center mb-16">
                        <h2 className="text-4xl font-bold tracking-tight text-black mb-4">Hard Truths.</h2>
                        <p className="text-gray-500">Common questions about the new reality of engineering.</p>
                    </div>

                    <div className="space-y-4">
                        {questions.map((item, i) => (
                            <div key={i} className="border border-black/10 rounded-lg overflow-hidden bg-[#F5F5F7] hover:border-black/30 transition-colors">
                                <button
                                    onClick={() => toggle(i)}
                                    className="w-full flex items-center justify-between p-6 text-left"
                                >
                                    <h3 className="text-lg font-bold text-black flex items-center gap-3">
                                        <span className="text-gray-400 font-mono text-xs opacity-50">0{i + 1}</span>
                                        {item.q}
                                    </h3>
                                    {openIndex === i ?
                                        <ChevronUp className="w-5 h-5 text-black" /> :
                                        <ChevronDown className="w-5 h-5 text-gray-400" />
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
                                        <p className="text-gray-600 leading-relaxed border-t border-black/5 pt-4">
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
    )
}

function JoinCTA() {


    return (
        <section id="join" className="py-24 bg-black text-white border-t border-white/10">
            <div className="max-w-[1200px] mx-auto px-6 grid md:grid-cols-2 gap-12 items-center">
                <FadeIn>
                    <div className="inline-flex items-center gap-2 text-green-500 font-mono text-xs mb-6 bg-green-900/20 px-3 py-1 rounded border border-green-900/50">
                        <div className="w-1.5 h-1.5 bg-green-500 rounded-full animate-pulse" />
                        System Online • Registration Open
                    </div>

                    <h2 className="text-3xl md:text-5xl font-bold tracking-tighter mb-6">
                        Initialize Your <span className="text-gray-500">Node.</span>
                    </h2>
                    <p className="text-gray-400 max-w-md leading-relaxed mb-8">
                        The protocol is live. Connect your GitHub, verify your skills, and start earning reputation immediately. No waitlist. No interviews. Just code.
                    </p>

                    <SmartAuthLink role="talent" loggedInHref="/talent/dashboard" guestHref="/auth?role=talent" className="inline-flex items-center gap-2 bg-white text-black font-bold uppercase tracking-widest px-8 py-4 hover:bg-gray-200 transition-colors text-xs rounded">
                        Start Onboarding <ArrowRight className="w-4 h-4" />
                    </SmartAuthLink>

                    <p className="text-xs text-gray-500 mt-6">* GitHub/GitLab integration available upon access.</p>
                </FadeIn>

                <div className="hidden md:flex justify-end opacity-50 relative">
                    <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-32 h-32 bg-green-500/20 blur-[100px]"></div>
                    <Terminal className="w-64 h-64 stroke-[0.5] relative z-10" />
                </div>
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

export default function LandingPage() {
    const [isManifestoOpen, setIsManifestoOpen] = useState(false);
    const [isProtocolOpen, setIsProtocolOpen] = useState(false);
    const [isLegalOpen, setIsLegalOpen] = useState(false);

    return (
        <div className="min-h-screen bg-[#F5F5F7] text-black font-sans selection:bg-black selection:text-white overflow-x-hidden">
            <Navbar />
            <Hero />
            <ProtocolSteps />
            <MissionBoard />
            <MissionBoard />
            <FAQ />
            <JoinCTA />
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
