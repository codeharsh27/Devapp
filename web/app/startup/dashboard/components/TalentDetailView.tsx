"use client";
import { ArrowLeft, Github, Globe, Mail, MessageSquare, ExternalLink, Award, Code2, Zap, Layout, ShieldCheck, Lock } from "lucide-react";

const MOCK_PROFILE = {
    id: 1,
    name: "Alex Dev",
    role: "Backend Architecture Specialist",
    bio: "I build high-scale distributed systems. Focused on Node.js performance and database optimization. Previously scaled systems to 100k+ concurrent users.",
    stats: {
        dropsCompleted: 12,
        totalBountyEarned: "$6,500",
        codeQualityScore: 98,
        onTimeDelivery: "100%"
    },
    skills: ["Node.js", "PostgreSQL", "Redis", "System Design", "AWS Lambda", "Docker"],
    portfolio: [
        {
            id: 101,
            title: "Fix Stripe Webhook Latency",
            category: "Backend",
            company: "FinTech Co.",
            isPrivate: true,
            date: "2 days ago",
            bounty: 500,
            outcome: "Reduced latency by 95% using Redis queue.",
            links: { repo: "#", demo: "#" },
            rating: 5
        },
        {
            id: 102,
            title: "Optimize Database Queries",
            category: "Database",
            company: "E-Comm Inc.",
            isPrivate: false,
            date: "1 week ago",
            bounty: 800,
            outcome: "Rewrote slow SQL queries, improved load time by 2s.",
            links: { repo: "#" },
            rating: 5
        },
        {
            id: 103,
            title: "Auth Service Microservice",
            category: "Architecture",
            company: "SaaS Startup",
            isPrivate: true,
            date: "1 month ago",
            bounty: 1200,
            outcome: "Decoupled auth from monolith. Implemented JWT flow.",
            links: { repo: "#", demo: "#" },
            rating: 5
        }
    ]
};

export function TalentDetailView({ talentId, onBack, onMessage }: { talentId: string | number, onBack: () => void, onMessage: (name: string, isInvite?: boolean) => void }) {
    // In real app, fetch talent profile by ID
    const profile = MOCK_PROFILE;

    return (
        <div className="max-w-5xl mx-auto p-8 animate-in fade-in slide-in-from-right-8 duration-300 pb-24">

            {/* Nav */}
            <button onClick={onBack} className="flex items-center gap-2 text-zinc-500 hover:text-white mb-8 transition-colors group">
                <ArrowLeft className="w-4 h-4 group-hover:-translate-x-1 transition-transform" /> Back to Talent Library
            </button>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">

                {/* Left: Profile Card */}
                <div className="space-y-6">
                    <div className="bg-[#0c0c0e] border border-zinc-800 rounded-2xl p-6 text-center relative overflow-hidden">
                        <div className="absolute top-0 inset-x-0 h-1 bg-gradient-to-r from-indigo-500 to-purple-500"></div>

                        <div className="w-24 h-24 mx-auto bg-zinc-900 rounded-full flex items-center justify-center border-2 border-zinc-800 mb-4 shadow-xl">
                            <span className="text-3xl font-bold text-zinc-400">{profile.name.charAt(0)}</span>
                        </div>

                        <h1 className="text-xl font-medium text-white mb-1">{profile.name}</h1>
                        <p className="text-sm text-zinc-500 mb-4">{profile.role}</p>

                        <div className="flex items-center justify-center gap-2 mb-6">
                            <span className="bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wide flex items-center gap-1">
                                <ShieldCheck className="w-3 h-3" /> Verified
                            </span>
                        </div>

                        {/* Socials & Actions */}
                        <div className="flex gap-2 justify-center mb-6">
                            <button className="p-2 bg-zinc-900 border border-zinc-800 rounded-lg text-zinc-400 hover:text-white hover:border-zinc-700 transition-colors">
                                <Github className="w-4 h-4" />
                            </button>
                            <button className="p-2 bg-zinc-900 border border-zinc-800 rounded-lg text-zinc-400 hover:text-white hover:border-zinc-700 transition-colors">
                                <Globe className="w-4 h-4" />
                            </button>
                            <button
                                onClick={() => onMessage(profile.name, false)}
                                className="p-2 bg-zinc-900 border border-zinc-800 rounded-lg text-zinc-400 hover:text-white hover:border-zinc-700 transition-colors"
                            >
                                <MessageSquare className="w-4 h-4" />
                            </button>
                        </div>

                        <button
                            onClick={() => onMessage(profile.name, true)}
                            className="w-full py-2.5 bg-white text-black rounded-xl font-medium hover:bg-zinc-200 transition-colors flex items-center justify-center gap-2"
                        >
                            Send Invite
                        </button>

                        <div className="mt-6 pt-6 border-t border-zinc-800/50 text-left space-y-4">
                            <div>
                                <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-2">Primary Skills</h3>
                                <div className="flex flex-wrap gap-1.5">
                                    {profile.skills.map(skill => (
                                        <span key={skill} className="px-2 py-1 bg-zinc-900 border border-zinc-800 text-zinc-400 rounded-md text-xs">
                                            {skill}
                                        </span>
                                    ))}
                                </div>
                            </div>

                            <div>
                                <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-2">About</h3>
                                <p className="text-sm text-zinc-400 leading-relaxed">
                                    {profile.bio}
                                </p>
                            </div>
                        </div>
                    </div>

                    {/* Stats */}
                    <div className="grid grid-cols-2 gap-4">
                        <div className="bg-zinc-900/30 border border-zinc-800/50 p-4 rounded-xl text-center">
                            <div className="text-2xl font-light text-white mb-1">{profile.stats.dropsCompleted}</div>
                            <div className="text-[10px] text-zinc-500 uppercase tracking-widest">completed drops</div>
                        </div>
                        <div className="bg-zinc-900/30 border border-zinc-800/50 p-4 rounded-xl text-center">
                            <div className="text-2xl font-light text-emerald-400 mb-1">{profile.stats.codeQualityScore}</div>
                            <div className="text-[10px] text-zinc-500 uppercase tracking-widest">Quality Score</div>
                        </div>
                    </div>
                </div>

                {/* Right: Proof of Work */}
                <div className="lg:col-span-2 space-y-6">
                    <h2 className="text-lg font-light text-zinc-100 flex items-center gap-2">
                        <Code2 className="w-5 h-5 text-zinc-500" /> Proof of Work
                    </h2>

                    <div className="space-y-4">
                        {profile.portfolio.map((work) => (
                            <div key={work.id} className="bg-[#0c0c0e] border border-zinc-800 rounded-xl p-6 hover:border-zinc-700 transition-all group">
                                <div className="flex justify-between items-start mb-2">
                                    <div>
                                        <h3 className="text-base font-medium text-zinc-200 group-hover:text-white transition-colors">{work.title}</h3>
                                        <div className="flex items-center gap-2 text-xs text-zinc-500 mt-1">
                                            <span className="text-zinc-400 font-medium">{work.company}</span>
                                            <span>•</span>
                                            <span>{work.category}</span>
                                            <span>•</span>
                                            <span>{work.date}</span>
                                        </div>
                                    </div>
                                    <div className="text-right">
                                        <div className="text-sm font-medium text-emerald-400">${work.bounty}</div>
                                        <div className="text-[10px] text-zinc-600 uppercase">Bounty Earned</div>
                                    </div>
                                </div>

                                <p className="text-sm text-zinc-400 leading-relaxed bg-zinc-900/50 p-3 rounded-lg border border-zinc-800/50 mb-4">
                                    "{work.outcome}"
                                </p>

                                <div className="flex items-center gap-3">
                                    {work.isPrivate ? (
                                        <div className="flex items-center gap-2 px-3 py-1.5 bg-zinc-900/50 border border-zinc-800/50 rounded-lg text-xs font-medium text-zinc-500 cursor-not-allowed">
                                            <Lock className="w-3.5 h-3.5" /> Private Repo
                                        </div>
                                    ) : (
                                        <button className="flex items-center gap-1.5 px-3 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-xs font-medium text-zinc-400 hover:text-white hover:border-zinc-600 transition-colors">
                                            <Github className="w-3.5 h-3.5" /> View Code
                                        </button>
                                    )}

                                    {work.links.demo && !work.isPrivate && (
                                        <button className="flex items-center gap-1.5 px-3 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-xs font-medium text-zinc-400 hover:text-white hover:border-zinc-600 transition-colors">
                                            <ExternalLink className="w-3.5 h-3.5" /> Live Demo
                                        </button>
                                    )}
                                </div>
                            </div>
                        ))}
                    </div>
                </div>

            </div>

        </div>
    );
}
