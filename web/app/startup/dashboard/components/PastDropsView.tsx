"use client";
import { MoreHorizontal, Users, Clock, CheckCircle2, AlertCircle, ArrowUpRight, X, MessageSquare, Download, ExternalLink, Github } from "lucide-react";
import { Space_Grotesk } from "next/font/google";
import { useState, useRef, useEffect } from "react";
import { supabase } from "@/lib/supabaseClient";

const spaceGrotesk = Space_Grotesk({
    subsets: ["latin"],
    weight: ["300", "400", "500"]
});

// --- Types ---
type DropStatus = 'Open' | 'In Progress' | 'In Review' | 'Completed' | 'Disputed';

interface UserProfile {
    name: string;
    avatarInitials: string;
    color: string; // Tailwind color class for bg (e.g. 'bg-indigo-500')
}

interface Drop {
    id: string;
    title: string;
    type: string;
    status: DropStatus;
    date: string;
    bounty: string;
    contributor?: UserProfile | null;
    reviewer?: UserProfile | null;
    applicantCount?: number;
    description?: string;
    repoLink?: string;
}

// --- Mock Data ---
const MOCK_DROPS: Drop[] = [
    {
        id: '1',
        title: "Fix Stripe Webhook Latency",
        type: "Backend / API",
        status: "Completed",
        date: "2 days ago",
        bounty: "$500",
        contributor: { name: "alex_dev", avatarInitials: "AD", color: "indigo" },
        reviewer: { name: "sarah_lead", avatarInitials: "SL", color: "pink" },
        description: "Diagnose and fix the 500ms delay in Stripe webhook processing. Optimize database transaction handling.",
        repoLink: "https://github.com/acme/backend/pull/123"
    },
    {
        id: '2',
        title: "Mobile App Auth Flow",
        type: "Mobile / Auth",
        status: "In Progress",
        date: "5 days ago",
        bounty: "$1.2k",
        contributor: { name: "mobile_pro", avatarInitials: "MP", color: "blue" },
        reviewer: { name: "mike_cto", avatarInitials: "MC", color: "purple" },
        description: "Implement OAuth2 social login (Google & Apple) for the React Native mobile app.",
    },
    {
        id: '3',
        title: "Integrate Supabase Vector Store",
        type: "Database",
        status: "Open", // Waiting for applicants
        date: "Just now",
        bounty: "$350",
        applicantCount: 12,
        reviewer: { name: "sarah_lead", avatarInitials: "SL", color: "pink" },
        description: "Set up pgvector extension and create embeddings generation function for user data."
    },
    {
        id: '4',
        title: "Landing Page Redesign",
        type: "Frontend / UI",
        status: "In Review",
        date: "1 week ago",
        bounty: "$800",
        contributor: { name: "ui_master", avatarInitials: "UI", color: "emerald" },
        reviewer: { name: "anna_pm", avatarInitials: "AP", color: "orange" },
        description: "Implement new Figma design for the landing page using Tailwind CSS. Ensure mobile responsiveness.",
        repoLink: "https://github.com/acme/frontend/pull/456"
    },
    {
        id: '5',
        title: "Optimize Image Loading",
        type: "Optimization",
        status: "Open",
        date: "1 hour ago",
        bounty: "$200",
        applicantCount: 3,
        reviewer: { name: "mike_cto", avatarInitials: "MC", color: "purple" },
        description: "Implement lazy loading and Next.js Image component optimization for the gallery page."
    },
];

// --- Helper Components ---

function ProfileAvatar({ user, role }: { user?: UserProfile | null, role: string }) {
    if (!user) return <span className="text-zinc-600 text-xs italic">Unassigned</span>;

    return (
        <div className="flex items-center gap-2 group cursor-pointer">
            <div className={`w-6 h-6 rounded-full flex items-center justify-center text-[10px] font-bold border border-white/5 shadow-sm text-white ${`bg-${user.color}-600`}`}>
                {user.avatarInitials}
            </div>
            <div className="flex flex-col">
                <span className="text-sm text-zinc-300 group-hover:text-white transition-colors truncate max-w-[100px]">
                    @{user.name}
                </span>
            </div>
        </div>
    );
}

function StatusBadge({ status }: { status: DropStatus }) {
    const styles = {
        'Open': 'bg-zinc-800 text-zinc-300 border-zinc-700',
        'In Progress': 'bg-blue-500/10 text-blue-400 border-blue-500/20',
        'In Review': 'bg-amber-500/10 text-amber-400 border-amber-500/20',
        'Completed': 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20',
        'Disputed': 'bg-red-500/10 text-red-400 border-red-500/20',
    };

    const icons = {
        'Open': <Users className="w-3 h-3" />,
        'In Progress': <Clock className="w-3 h-3" />,
        'In Review': <AlertCircle className="w-3 h-3" />,
        'Completed': <CheckCircle2 className="w-3 h-3" />,
        'Disputed': <AlertCircle className="w-3 h-3" />,
    };

    return (
        <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-medium border ${styles[status]}`}>
            {icons[status]}
            {status}
        </span>
    );
}

// --- Drawer Component ---
function MissionDrawer({ drop, onClose, onMessage }: { drop: Drop | null, onClose: () => void, onMessage: () => void }) {
    const drawerRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        function handleClickOutside(event: MouseEvent) {
            if (drawerRef.current && !drawerRef.current.contains(event.target as Node)) {
                onClose();
            }
        }
        if (drop) document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, [drop, onClose]);

    if (!drop) return null;

    return (
        <div className="fixed inset-0 z-50 flex justify-end bg-black/50 backdrop-blur-sm animate-in fade-in duration-200">
            <div ref={drawerRef} className="w-full max-w-xl h-full bg-[#0c0c0e] border-l border-zinc-800 shadow-2xl overflow-y-auto animate-in slide-in-from-right duration-300 p-8">

                {/* Header */}
                <div className="flex items-start justify-between mb-8">
                    <div>
                        <div className="flex items-center gap-3 mb-2">
                            <StatusBadge status={drop.status} />
                            <span className="text-xs text-zinc-500 font-mono">{drop.bounty} Bounty</span>
                        </div>
                        <h2 className={`text-2xl font-light text-zinc-100 ${spaceGrotesk.className}`}>{drop.title}</h2>
                    </div>
                    <button onClick={onClose} className="p-2 hover:bg-zinc-800 rounded-full text-zinc-500 hover:text-white transition-colors">
                        <X className="w-5 h-5" />
                    </button>
                </div>

                {/* Content */}
                <div className="space-y-8">
                    {/* Description */}
                    <div>
                        <h4 className="text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Description</h4>
                        <p className="text-zinc-300 text-sm leading-relaxed">{drop.description}</p>
                    </div>

                    {/* People */}
                    <div className="grid grid-cols-2 gap-4">
                        <div className="bg-zinc-900/50 p-4 rounded-xl border border-zinc-800/50">
                            <span className="text-xs font-bold text-zinc-500 uppercase tracking-wider block mb-3">Contributor</span>
                            {drop.status === 'Open' ? (
                                <div className="space-y-3">
                                    <div className="flex items-center gap-2 text-zinc-400 text-sm">
                                        <Users className="w-4 h-4" /> {drop.applicantCount} active applicants
                                    </div>
                                    <button className="text-xs bg-white text-black font-semibold px-3 py-1.5 rounded-lg w-full hover:bg-zinc-200 transition-colors">
                                        Review Applicants
                                    </button>
                                </div>
                            ) : (
                                <ProfileAvatar user={drop.contributor} role="Contributor" />
                            )}
                        </div>
                        <div className="bg-zinc-900/50 p-4 rounded-xl border border-zinc-800/50">
                            <span className="text-xs font-bold text-zinc-500 uppercase tracking-wider block mb-3">Reviewer</span>
                            <ProfileAvatar user={drop.reviewer} role="Reviewer" />
                        </div>
                    </div>

                    {/* Resources & Links */}
                    {drop.repoLink && (
                        <div>
                            <h4 className="text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Resources</h4>
                            <a href={drop.repoLink} target="_blank" rel="noopener noreferrer" className="flex items-center justify-between p-3 rounded-lg border border-zinc-800 hover:bg-zinc-900 transition-colors group">
                                <div className="flex items-center gap-3">
                                    <Github className="w-5 h-5 text-zinc-500 group-hover:text-white" />
                                    <div className="flex flex-col">
                                        <span className="text-sm font-medium text-zinc-300 group-hover:text-white">Pull Request / Repo</span>
                                        <span className="text-xs text-zinc-500 truncate max-w-[200px]">{drop.repoLink}</span>
                                    </div>
                                </div>
                                <ExternalLink className="w-4 h-4 text-zinc-500 group-hover:text-white" />
                            </a>
                        </div>
                    )}

                    {/* Actions Area */}
                    <div className="pt-8 border-t border-zinc-800 grid grid-cols-2 gap-4">
                        <button
                            onClick={onMessage}
                            className="flex items-center justify-center gap-2 p-3 rounded-xl border border-zinc-700 hover:bg-zinc-800 text-zinc-300 transition-colors text-sm font-medium"
                        >
                            <MessageSquare className="w-4 h-4" /> Message
                        </button>
                        {drop.status === 'In Review' && (
                            <button className="flex items-center justify-center gap-2 p-3 rounded-xl bg-green-600 hover:bg-green-500 text-white transition-colors text-sm font-medium">
                                <CheckCircle2 className="w-4 h-4" /> Approve Work
                            </button>
                        )}
                        {drop.status === 'Open' && (
                            <button className="flex items-center justify-center gap-2 p-3 rounded-xl bg-white hover:bg-zinc-200 text-black transition-colors text-sm font-medium">
                                Edit Mission
                            </button>
                        )}
                        {drop.status === 'Completed' && (
                            <button className="flex items-center justify-center gap-2 p-3 rounded-xl border border-zinc-700 hover:bg-zinc-800 text-zinc-300 transition-colors text-sm font-medium">
                                <Download className="w-4 h-4" /> Download Report
                            </button>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
}

// --- Message Selection Modal ---
function MessageSelectionModal({ isOpen, onClose, onSelect }: { isOpen: boolean, onClose: () => void, onSelect: (role: 'contributor' | 'reviewer') => void }) {
    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
            <div className="bg-[#0c0c0e] border border-zinc-800 p-6 rounded-2xl shadow-2xl max-w-sm w-full animate-in zoom-in-95 duration-200">
                <h3 className={`text-xl font-light text-white mb-2 ${spaceGrotesk.className}`}>Start Conversation</h3>
                <p className="text-zinc-500 text-sm mb-6">Who would you like to message regarding this mission?</p>

                <div className="space-y-3">
                    <button
                        onClick={() => onSelect('contributor')}
                        className="w-full flex items-center gap-3 p-3 rounded-xl border border-zinc-800 hover:bg-zinc-900 transition-colors group text-left"
                    >
                        <div className="w-8 h-8 rounded-full bg-zinc-800 flex items-center justify-center text-zinc-400 group-hover:text-white group-hover:bg-zinc-700">
                            <Users className="w-4 h-4" />
                        </div>
                        <div>
                            <span className="block text-sm font-medium text-zinc-300 group-hover:text-white">Contributor</span>
                            <span className="block text-xs text-zinc-500">Discuss implementation details</span>
                        </div>
                    </button>

                    <button
                        onClick={() => onSelect('reviewer')}
                        className="w-full flex items-center gap-3 p-3 rounded-xl border border-zinc-800 hover:bg-zinc-900 transition-colors group text-left"
                    >
                        <div className="w-8 h-8 rounded-full bg-zinc-800 flex items-center justify-center text-zinc-400 group-hover:text-white group-hover:bg-zinc-700">
                            <CheckCircle2 className="w-4 h-4" />
                        </div>
                        <div>
                            <span className="block text-sm font-medium text-zinc-300 group-hover:text-white">Reviewer</span>
                            <span className="block text-xs text-zinc-500">Ask about review status</span>
                        </div>
                    </button>
                </div>

                <button
                    onClick={onClose}
                    className="mt-6 w-full py-2 text-xs font-medium text-zinc-500 hover:text-zinc-300 transition-colors"
                >
                    Cancel
                </button>
            </div>
        </div>
    );
}

export function PastDropsView({ onMessageRedirect }: { onMessageRedirect?: (user: { name: string, role: string, dropId: string }) => void }) {
    const [selectedDrop, setSelectedDrop] = useState<Drop | null>(null);
    const [activeTab, setActiveTab] = useState('All');
    const [actionMenuOpen, setActionMenuOpen] = useState<string | null>(null);
    const [messageModalOpen, setMessageModalOpen] = useState(false);
    const [drops, setDrops] = useState<Drop[]>(MOCK_DROPS);

    useEffect(() => {
        const fetchMissions = async () => {
            const { data: { session } } = await supabase.auth.getSession();
            if (!session) return;

            const { data, error } = await supabase
                .from('missions')
                .select('*')
                .eq('user_id', session.user.id)
                .order('created_at', { ascending: false });

            if (data) {
                const realDrops: any[] = data.map(m => ({
                    id: m.id,
                    title: m.title,
                    type: m.category || 'General',
                    status: m.status || 'Open',
                    date: new Date(m.created_at).toLocaleDateString(),
                    bounty: `$${m.bounty}`,
                    applicantCount: 0,
                    description: m.description,
                    reviewer: { name: "You", avatarInitials: "ME", color: "indigo" }
                }));
                setDrops([...realDrops, ...MOCK_DROPS]);
            }
        };

        fetchMissions();

        const channel = supabase.channel('missions_db_changes')
            .on('postgres_changes', { event: '*', schema: 'public', table: 'missions' }, () => {
                fetchMissions();
            })
            .subscribe();

        return () => {
            supabase.removeChannel(channel);
        };
    }, []);

    // Close action menu when clicking outside
    useEffect(() => {
        const handleClickOutside = () => setActionMenuOpen(null);
        window.addEventListener('click', handleClickOutside);
        return () => window.removeEventListener('click', handleClickOutside);
    }, []);

    const filteredDrops = drops.filter(drop => {
        if (activeTab === 'All') return true;
        if (activeTab === 'Open') return drop.status === 'Open';
        if (activeTab === 'Active') return ['In Progress', 'In Review', 'Disputed'].includes(drop.status);
        if (activeTab === 'History') return drop.status === 'Completed';
        return true;
    });

    const handleMessageSelect = (role: 'contributor' | 'reviewer') => {
        setMessageModalOpen(false);
        const user = role === 'contributor' ? selectedDrop?.contributor : selectedDrop?.reviewer;

        if (user && selectedDrop && onMessageRedirect) {
            onMessageRedirect({
                name: user.name,
                role: `${role.charAt(0).toUpperCase() + role.slice(1)}`,
                dropId: selectedDrop.id
            });
        }
    };

    return (
        <div className="flex-1 p-8 lg:p-12 pt-32 animate-in fade-in duration-500 relative">
            <MissionDrawer
                drop={selectedDrop}
                onClose={() => setSelectedDrop(null)}
                onMessage={() => setMessageModalOpen(true)}
            />
            <MessageSelectionModal
                isOpen={messageModalOpen}
                onClose={() => setMessageModalOpen(false)}
                onSelect={handleMessageSelect}
            />

            <div className="max-w-7xl mx-auto space-y-8">
                {/* Header Section */}
                <div className="flex items-center justify-between">
                    <div>
                        <h2 className={`text-3xl font-light text-zinc-100 ${spaceGrotesk.className}`}>Mission Control</h2>
                        <p className="text-zinc-500 mt-1">Track active drops, review submissions, and manage history.</p>
                    </div>
                    {/* Filter Tabs */}
                    <div className="bg-[#09090b] border border-zinc-800 p-1 rounded-lg flex items-center gap-1">
                        {['All', 'Open', 'Active', 'History'].map((tab) => (
                            <button
                                key={tab}
                                onClick={() => setActiveTab(tab)}
                                className={`px-4 py-1.5 text-xs font-medium rounded-md transition-all ${activeTab === tab ? 'bg-zinc-800 text-white shadow-sm' : 'text-zinc-500 hover:text-zinc-300 hover:bg-zinc-900'}`}
                            >
                                {tab}
                            </button>
                        ))}
                    </div>
                </div>

                <div className="grid gap-4">
                    {/* Table Header */}
                    <div className="grid grid-cols-12 gap-4 px-6 py-3 text-[10px] font-bold text-zinc-500 uppercase tracking-wider border-b border-zinc-800/50">
                        <div className="col-span-4 pl-2">Mission</div>
                        <div className="col-span-2">Contributor</div>
                        <div className="col-span-2">Reviewer</div>
                        <div className="col-span-2">Status</div>
                        <div className="col-span-1">Bounty</div>
                        <div className="col-span-1 text-right pr-2">Action</div>
                    </div>

                    {/* Drops List */}
                    <div className="space-y-2">
                        {filteredDrops.map((drop) => (
                            <div
                                key={drop.id}
                                onClick={() => setSelectedDrop(drop)}
                                className="grid grid-cols-12 gap-4 items-center px-6 py-4 rounded-xl border border-zinc-800/40 bg-zinc-900/10 hover:bg-zinc-900/40 hover:border-zinc-700 transition-all group cursor-pointer active:scale-[0.99] relative"
                            >
                                {/* Mission Info */}
                                <div className="col-span-4 pl-2">
                                    <h4 className="font-medium text-zinc-200 group-hover:text-white transition-colors truncate pr-4 text-sm">
                                        {drop.title}
                                    </h4>
                                    <div className="flex items-center gap-2 mt-1">
                                        <span className="text-xs text-zinc-500">{drop.type}</span>
                                        <span className="text-[10px] text-zinc-600">• {drop.date}</span>
                                    </div>
                                </div>

                                {/* Contributor Column */}
                                <div className="col-span-2">
                                    {drop.status === 'Open' ? (
                                        <div className="inline-flex items-center gap-2 px-2 py-1 bg-zinc-800/50 rounded-md border border-zinc-800 hover:border-zinc-600 transition-colors cursor-pointer group/applicants">
                                            <div className="flex -space-x-1.5">
                                                <div className="w-4 h-4 rounded-full bg-zinc-700 border border-zinc-900"></div>
                                                <div className="w-4 h-4 rounded-full bg-zinc-600 border border-zinc-900"></div>
                                                <div className="w-4 h-4 rounded-full bg-zinc-500 border border-zinc-900"></div>
                                            </div>
                                            <span className="text-xs text-zinc-400 group-hover/applicants:text-zinc-200">
                                                {drop.applicantCount} Applicants
                                            </span>
                                        </div>
                                    ) : (
                                        <ProfileAvatar user={drop.contributor} role="Contributor" />
                                    )}
                                </div>

                                {/* Reviewer Column */}
                                <div className="col-span-2">
                                    <ProfileAvatar user={drop.reviewer} role="Reviewer" />
                                </div>

                                {/* Status */}
                                <div className="col-span-2">
                                    <StatusBadge status={drop.status} />
                                </div>

                                {/* Bounty */}
                                <div className="col-span-1 font-mono text-sm text-zinc-300">
                                    {drop.bounty}
                                </div>

                                {/* Actions */}
                                <div className="col-span-1 flex justify-end pr-2 relative">
                                    <button
                                        onClick={(e) => {
                                            e.stopPropagation();
                                            setActionMenuOpen(actionMenuOpen === drop.id ? null : drop.id);
                                        }}
                                        className={`p-2 rounded-lg transition-colors ${actionMenuOpen === drop.id ? 'bg-zinc-800 text-white' : 'text-zinc-500 hover:text-white hover:bg-zinc-800'}`}
                                    >
                                        <MoreHorizontal className="w-4 h-4" />
                                    </button>

                                    {/* Action Dropdown Menu */}
                                    {actionMenuOpen === drop.id && (
                                        <div className="absolute right-0 top-10 w-48 bg-[#0c0c0e] border border-zinc-800 rounded-xl shadow-xl z-20 animate-in fade-in slide-in-from-top-2 duration-200 overflow-hidden">
                                            <div className="p-1">
                                                <button
                                                    onClick={(e) => {
                                                        e.stopPropagation();
                                                        setSelectedDrop(drop);
                                                        setActionMenuOpen(null);
                                                    }}
                                                    className="w-full flex items-center gap-2 px-3 py-2 text-sm text-zinc-300 hover:text-white hover:bg-zinc-800/50 rounded-lg transition-colors text-left"
                                                >
                                                    <ArrowUpRight className="w-4 h-4" />
                                                    Open Mission
                                                </button>

                                            </div>
                                        </div>
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
