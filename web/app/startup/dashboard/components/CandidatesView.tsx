"use client";
import { useState, useMemo } from "react";
import {
    Search, Filter, MoreHorizontal, User, FileText, CheckCircle2, XCircle,
    MessageSquare, Clock, ArrowUpRight, Github, Code2, Zap, Layout, Terminal
} from "lucide-react";
import { Space_Grotesk } from "next/font/google";

const spaceGrotesk = Space_Grotesk({
    subsets: ["latin"],
    weight: ["300", "400", "500", "600"],
});

// TYPES
type SubmissionStatus = 'Shortlisted' | 'Pending Review' | 'Changes Requested' | 'Accepted' | 'Rejected';

interface Submission {
    id: string;
    missionTitle: string;
    developerName: string;
    developerAvatarInitials: string;
    developerColor: string;
    status: SubmissionStatus;
    submittedAt: string;
    repoUrl: string;
    liveUrl?: string;
    matchScore: number; // 0-100
    aiSummary: string;
    technologies: string[];
}

// MOCK DATA
const MOCK_SUBMISSIONS: Submission[] = [
    {
        id: "s1",
        missionTitle: "Integrate Stripe Connect",
        developerName: "Elena Rodriguez",
        developerAvatarInitials: "ER",
        developerColor: "emerald",
        status: "Shortlisted",
        submittedAt: "2h ago",
        repoUrl: "github.com/elena/stripe-connect-module",
        liveUrl: "https://stripe-demo.vercel.app",
        matchScore: 98,
        aiSummary: "Perfect implementation of the intent. Handles edge cases for failed webhooks. Clean, typed code.",
        technologies: ["Node.js", "Stripe SDK", "TypeScript"]
    },
    {
        id: "s2",
        missionTitle: "Landing Page Redesign",
        developerName: "David Chen",
        developerAvatarInitials: "DC",
        developerColor: "blue",
        status: "Pending Review",
        submittedAt: "5h ago",
        repoUrl: "github.com/davidc/landing-v2",
        matchScore: 85,
        aiSummary: "Visuals match the Figma file exactly. However, mobile responsiveness breaks on iPhone SE.",
        technologies: ["React", "Tailwind", "Framer Motion"]
    },
    {
        id: "s3",
        missionTitle: "Mobile Auth Flow",
        developerName: "Sarah Miller",
        developerAvatarInitials: "SM",
        developerColor: "pink",
        status: "Changes Requested",
        submittedAt: "1d ago",
        repoUrl: "github.com/sarahm/flutter-auth",
        matchScore: 72,
        aiSummary: "Logic is sound but lacks error handling for network timeouts.",
        technologies: ["Flutter", "Dart", "Firebase"]
    },
    {
        id: "s4",
        missionTitle: "Database Migration",
        developerName: "James Wilson",
        developerAvatarInitials: "JW",
        developerColor: "amber",
        status: "Rejected",
        submittedAt: "2d ago",
        repoUrl: "github.com/jwilson/db-migration",
        matchScore: 40,
        aiSummary: "Failed to compile. Missing dependency in package.json.",
        technologies: ["PostgreSQL", "SQL"]
    }
];

export function CandidatesView({ onMessageRedirect }: { onMessageRedirect?: (user: { name: string, role: string, dropId: string }) => void }) {
    const [searchQuery, setSearchQuery] = useState("");
    const [selectedStatus, setSelectedStatus] = useState<SubmissionStatus | 'All'>('All');
    const [selectedSubmission, setSelectedSubmission] = useState<Submission | null>(null);

    const filteredSubmissions = useMemo(() => {
        return MOCK_SUBMISSIONS.filter(s => {
            const matchesSearch = s.developerName.toLowerCase().includes(searchQuery.toLowerCase()) ||
                s.missionTitle.toLowerCase().includes(searchQuery.toLowerCase());
            const matchesStatus = selectedStatus === 'All' || s.status === selectedStatus;
            return matchesSearch && matchesStatus;
        });
    }, [searchQuery, selectedStatus]);

    const handleMessage = (e: React.MouseEvent, submission: Submission) => {
        e.stopPropagation();
        if (onMessageRedirect) {
            onMessageRedirect({
                name: submission.developerName,
                role: "Developer",
                dropId: 'submission_' + submission.id
            });
        }
    };

    return (
        <div className="flex-1 flex flex-col h-full bg-[#000000] pt-6 relative overflow-hidden">
            {/* Header */}
            <div className="px-8 lg:px-12 py-6 border-b border-zinc-800 flex flex-col md:flex-row md:items-end justify-between gap-6 shrink-0 bg-[#000000] z-10">
                <div>
                    <h2 className={`text-3xl font-light text-zinc-100 ${spaceGrotesk.className}`}>Submission Review</h2>
                    <p className="text-zinc-500 mt-1">Review code submissions, run tests, and approve payments.</p>
                </div>

                <div className="flex gap-3 w-full md:w-auto">
                    <div className="relative flex-1 md:w-64">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
                        <input
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            placeholder="Search missions or devs..."
                            className="w-full pl-10 pr-4 py-2.5 bg-[#09090b] border border-zinc-800 rounded-xl text-sm text-zinc-200 focus:outline-none focus:border-zinc-600 transition-colors"
                        />
                    </div>
                </div>
            </div>

            {/* List View */}
            <div className="flex-1 overflow-y-auto p-8 lg:p-12">
                <div className="max-w-7xl mx-auto space-y-6">

                    {/* Filter Tabs */}
                    <div className="flex gap-2 overflow-x-auto pb-2 no-scrollbar">
                        {['All', 'Shortlisted', 'Pending Review', 'Accepted'].map((status) => (
                            <button
                                key={status}
                                onClick={() => setSelectedStatus(status as any)}
                                className={`px-4 py-1.5 rounded-full text-xs font-medium border whitespace-nowrap transition-all ${selectedStatus === status
                                        ? 'bg-zinc-100 text-black border-zinc-100'
                                        : 'bg-zinc-900/50 text-zinc-500 border-zinc-800 hover:text-zinc-300 hover:border-zinc-600'
                                    }`}
                            >
                                {status}
                            </button>
                        ))}
                    </div>

                    {/* Submissions Grid */}
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                        {filteredSubmissions.length === 0 ? (
                            <div className="col-span-full text-center py-20 text-zinc-500">
                                <Code2 className="w-12 h-12 mx-auto mb-4 opacity-20" />
                                <p className="text-sm">No submissions found matching filter.</p>
                            </div>
                        ) : (
                            filteredSubmissions.map((sub) => (
                                <div
                                    key={sub.id}
                                    onClick={() => setSelectedSubmission(sub)}
                                    className="group bg-[#0c0c0e] border border-zinc-800 rounded-2xl p-5 hover:border-zinc-600 transition-all cursor-pointer hover:-translate-y-1 relative overflow-hidden"
                                >
                                    {/* Score Badge */}
                                    <div className={`absolute top-0 right-0 px-3 py-1.5 rounded-bl-2xl text-xs font-bold border-l border-b
                                        ${sub.matchScore >= 90 ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20' :
                                            sub.matchScore >= 70 ? 'bg-amber-500/10 text-amber-400 border-amber-500/20' :
                                                'bg-red-500/10 text-red-400 border-red-500/20'}`}>
                                        {sub.matchScore}% Match
                                    </div>

                                    {/* Mission Context */}
                                    <div className="mb-4">
                                        <h3 className="text-zinc-400 text-xs uppercase tracking-wider font-bold mb-1">Mission</h3>
                                        <p className="text-zinc-200 text-sm truncate font-medium">{sub.missionTitle}</p>
                                    </div>

                                    {/* Developer Info */}
                                    <div className="flex items-center gap-3 mb-4">
                                        <div className={`w-8 h-8 rounded-full flex items-center justify-center text-[10px] font-bold text-white border border-white/5 ${`bg-${sub.developerColor}-600`}`}>
                                            {sub.developerAvatarInitials}
                                        </div>
                                        <div>
                                            <p className="text-sm text-zinc-300 group-hover:text-white transition-colors">{sub.developerName}</p>
                                            <p className="text-[10px] text-zinc-600">{sub.submittedAt}</p>
                                        </div>
                                    </div>

                                    {/* Tech Stack */}
                                    <div className="flex flex-wrap gap-1.5 mb-4">
                                        {sub.technologies.slice(0, 3).map(tech => (
                                            <span key={tech} className="px-2 py-0.5 bg-zinc-900 border border-zinc-800 rounded text-[10px] text-zinc-500">
                                                {tech}
                                            </span>
                                        ))}
                                    </div>

                                    {/* Footer / Status */}
                                    <div className="flex items-center justify-between pt-4 border-t border-zinc-800/50">
                                        <div className={`text-xs font-medium px-2 py-1 rounded
                                            ${sub.status === 'Shortlisted' ? 'bg-indigo-500/10 text-indigo-400 border border-indigo-500/20' :
                                                sub.status === 'Accepted' ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' :
                                                    'bg-zinc-800 text-zinc-500'}`}>
                                            {sub.status}
                                        </div>
                                        <div className="flex gap-2">
                                            <button
                                                onClick={(e) => handleMessage(e, sub)}
                                                className="p-1.5 hover:bg-zinc-800 rounded-lg text-zinc-500 hover:text-white transition-colors"
                                            >
                                                <MessageSquare className="w-4 h-4" />
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            ))
                        )}
                    </div>
                </div>
            </div>

            {/* Submission Detail Drawer */}
            {selectedSubmission && (
                <div className="fixed inset-0 z-50 flex justify-end bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
                    <div className="w-full max-w-2xl h-full bg-[#09090b] border-l border-zinc-800 shadow-2xl flex flex-col animate-in slide-in-from-right duration-300">
                        {/* Drawer Header */}
                        <div className="p-6 border-b border-zinc-800 flex items-start justify-between bg-zinc-900/50">
                            <div>
                                <h2 className={`text-2xl font-bold text-white ${spaceGrotesk.className}`}>Submission Review</h2>
                                <p className="text-zinc-400 text-sm mt-1">{selectedSubmission.missionTitle}</p>
                            </div>
                            <button
                                onClick={() => setSelectedSubmission(null)}
                                className="p-2 hover:bg-zinc-800 rounded-full text-zinc-500 hover:text-white transition-colors"
                            >
                                <XCircle className="w-6 h-6" />
                            </button>
                        </div>

                        {/* Drawer Content */}
                        <div className="flex-1 overflow-y-auto p-6 space-y-8">

                            {/* AI Summary */}
                            <div className="bg-indigo-500/5 border border-indigo-500/10 rounded-xl p-4 flex gap-4">
                                <Zap className="w-5 h-5 text-indigo-400 shrink-0 mt-0.5" />
                                <div>
                                    <h4 className="text-sm font-bold text-indigo-400 mb-1">AI Code Analysis</h4>
                                    <p className="text-sm text-zinc-300 leading-relaxed">"{selectedSubmission.aiSummary}"</p>
                                </div>
                            </div>

                            {/* Repo & Live Links */}
                            <div className="grid grid-cols-2 gap-4">
                                <a href={`https://${selectedSubmission.repoUrl}`} target="_blank" rel="noreferrer" className="flex items-center gap-3 p-4 bg-zinc-900/50 border border-zinc-800 rounded-xl hover:bg-zinc-900 hover:border-zinc-700 transition-all group">
                                    <Github className="w-5 h-5 text-zinc-500 group-hover:text-white" />
                                    <div>
                                        <p className="text-xs text-zinc-500 uppercase font-bold">Repository</p>
                                        <p className="text-sm text-zinc-300 group-hover:text-blue-400 truncate w-48">{selectedSubmission.repoUrl}</p>
                                    </div>
                                    <ArrowUpRight className="w-4 h-4 text-zinc-600 ml-auto" />
                                </a>
                                {selectedSubmission.liveUrl ? (
                                    <a href={selectedSubmission.liveUrl} target="_blank" rel="noreferrer" className="flex items-center gap-3 p-4 bg-zinc-900/50 border border-zinc-800 rounded-xl hover:bg-zinc-900 hover:border-zinc-700 transition-all group">
                                        <Layout className="w-5 h-5 text-zinc-500 group-hover:text-white" />
                                        <div>
                                            <p className="text-xs text-zinc-500 uppercase font-bold">Live Demo</p>
                                            <p className="text-sm text-zinc-300 group-hover:text-blue-400 truncate w-48">vercel.app/demo-v2</p>
                                        </div>
                                        <ArrowUpRight className="w-4 h-4 text-zinc-600 ml-auto" />
                                    </a>
                                ) : (
                                    <div className="flex items-center justify-center p-4 border border-dashed border-zinc-800 rounded-xl text-zinc-600 text-sm">
                                        No Live Demo Provided
                                    </div>
                                )}
                            </div>

                            {/* Code Snippet / Terminal View (Mock) */}
                            <div>
                                <h3 className="text-sm font-semibold text-zinc-300 flex items-center gap-2 mb-3">
                                    <Terminal className="w-4 h-4 text-zinc-500" /> Automated Test Results
                                </h3>
                                <div className="bg-[#0c0c0e] border border-zinc-800 rounded-xl p-4 font-mono text-xs">
                                    <div className="flex items-center gap-2 text-emerald-400 mb-1">
                                        <CheckCircle2 className="w-3 h-3" /> 14 Tests Passed
                                    </div>
                                    <div className="flex items-center gap-2 text-zinc-500 mb-3">
                                        <XCircle className="w-3 h-3" /> 0 Tests Failed
                                    </div>
                                    <div className="text-zinc-600 pl-4 border-l border-zinc-800 space-y-1">
                                        <p>✓ Auth middleware handles 401</p>
                                        <p>✓ Stripe webhook signature verified</p>
                                        <p>✓ User session persists on refresh</p>
                                    </div>
                                </div>
                            </div>

                        </div>

                        {/* Footer Actions */}
                        <div className="p-6 border-t border-zinc-800 bg-[#09090b] grid grid-cols-2 gap-4">
                            <button className="py-3 bg-zinc-800 hover:bg-zinc-700 text-white rounded-xl font-medium transition-colors flex items-center justify-center gap-2">
                                Request Changes
                            </button>
                            <button className="py-3 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl font-bold transition-colors flex items-center justify-center gap-2 shadow-lg shadow-emerald-900/20">
                                <CheckCircle2 className="w-4 h-4" /> Accept & Pay
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
