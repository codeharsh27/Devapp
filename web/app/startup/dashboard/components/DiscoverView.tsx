"use client";
import { useState, useMemo } from "react";
import {
    Search, MapPin, Globe, Github, Linkedin, Twitter,
    ExternalLink, Code2, Palette, Database, Layout,
    Terminal, Cpu, Award, Zap, Star, MessageSquare
} from "lucide-react";
import { Space_Grotesk } from "next/font/google";

const spaceGrotesk = Space_Grotesk({
    subsets: ["latin"],
    weight: ["300", "400", "500", "600", "700"],
});

// --- Types ---
type RoleCategory = 'All' | 'Developer' | 'Designer' | 'Product Manager' | 'Data Scientist';

interface TalentProfile {
    id: string;
    name: string;
    role: string;
    category: RoleCategory;
    location: string;
    avatarInitials: string;
    avatarColor: string;
    skills: string[];
    bio: string;
    reputation: number;
    missionsCompleted: number;
    socials: {
        github?: string;
        linkedin?: string;
        twitter?: string;
        website?: string;
    };
    recentWork: string[];
    availability: 'Available' | 'Busy' | 'Open to Offers';
}

// --- Mock Data ---
const MOCK_TALENT: TalentProfile[] = [
    {
        id: "1",
        name: "Alex Rivera",
        role: "Senior Full Stack Dev",
        category: "Developer",
        location: "San Francisco, CA",
        avatarInitials: "AR",
        avatarColor: "indigo",
        skills: ["React", "Node.js", "PostgreSQL", "TypeScript"],
        bio: "Full stack wizard with 7 years of experience building scalable SaaS applications. Passionate about clean code and performance optimization.",
        reputation: 98,
        missionsCompleted: 42,
        socials: {
            github: "github.com/alexrivera",
            linkedin: "linkedin.com/in/alexrivera",
            website: "alexrivera.dev"
        },
        recentWork: ["Fintech Dashboard Redesign", "Real-time Chat Infra", "E-commerce API Migration"],
        availability: 'Available'
    },
    {
        id: "2",
        name: "Sarah Chen",
        role: "UI/UX Designer",
        category: "Designer",
        location: "New York, NY",
        avatarInitials: "SC",
        avatarColor: "pink",
        skills: ["Figma", "Prototyping", "Design Systems", "User Research"],
        bio: "Crafting intuitive and beautiful digital experiences. I bridge the gap between aesthetics and functionality.",
        reputation: 95,
        missionsCompleted: 28,
        socials: {
            twitter: "twitter.com/sarahdesign",
            website: "sarahchen.design"
        },
        recentWork: ["Mobile App UI Kit", "Travel Booking User Flow", "Corporate Brand Identity"],
        availability: 'Open to Offers'
    },
    {
        id: "3",
        name: "Marcus Johnson",
        role: "Backend Engineer",
        category: "Developer",
        location: "Austin, TX",
        avatarInitials: "MJ",
        avatarColor: "emerald",
        skills: ["Golang", "Kubernetes", "AWS", "Microservices"],
        bio: "Backend specialist focused on high-availability systems and cloud infrastructure. Docker captain and open source contributor.",
        reputation: 92,
        missionsCompleted: 35,
        socials: {
            github: "github.com/mjohnson",
            linkedin: "linkedin.com/in/mjohnson"
        },
        recentWork: ["Payment Gateway Integration", "Serverless Architecture Setup", "Legacy Code Refactor"],
        availability: 'Busy'
    },
    {
        id: "4",
        name: "Emily Davis",
        role: "Product Manager",
        category: "Product Manager",
        location: "Remote (London)",
        avatarInitials: "ED",
        avatarColor: "amber",
        skills: ["Agile", "Roadmapping", "Data Analysis", "User Stories"],
        bio: "Product leader who thrives in chaotic startup environments. I turn vague ideas into shipped products.",
        reputation: 89,
        missionsCompleted: 15,
        socials: {
            linkedin: "linkedin.com/in/emilydavis"
        },
        recentWork: ["Q3 Product Strategy", "User Onboarding Optimization", "Market Fit Analysis"],
        availability: 'Available'
    },
    {
        id: "5",
        name: "David Kim",
        role: "Data Scientist",
        category: "Data Scientist",
        location: "Toronto, ON",
        avatarInitials: "DK",
        avatarColor: "blue",
        skills: ["Python", "PyTorch", "NLP", "Data Visualization"],
        bio: "Turning data into actionable insights. PhD in Computer Science with a focus on Machine Learning.",
        reputation: 94,
        missionsCompleted: 19,
        socials: {
            github: "github.com/dkim_ml",
            twitter: "twitter.com/dkim_data"
        },
        recentWork: ["Churn Prediction Model", "Sentiment Analysis Pipeline", "Executive Dashboard Ops"],
        availability: 'Available'
    },
    {
        id: "6",
        name: "Olivia Martinez",
        role: "Frontend Developer",
        category: "Developer",
        location: "Barcelona, Spain",
        avatarInitials: "OM",
        avatarColor: "purple",
        skills: ["Vue.js", "Tailwind CSS", "Animation", "WebGL"],
        bio: "Creative developer who loves bringing designs to life with smooth animations and interactive elements.",
        reputation: 91,
        missionsCompleted: 24,
        socials: {
            github: "github.com/oliviam",
            website: "olivia.codes"
        },
        recentWork: ["Interactive Marketing Site", "Dashboard Data Viz", "Component Library Build"],
        availability: 'Open to Offers'
    }
];

// --- Components ---

function ProfileCard({ profile, onClick }: { profile: TalentProfile, onClick: () => void }) {
    return (
        <div
            onClick={onClick}
            className="group relative bg-[#0c0c0e] border border-zinc-800 rounded-2xl p-6 hover:bg-zinc-900/40 hover:border-zinc-700 transition-all cursor-pointer flex flex-col h-full"
        >
            <div className={`absolute top-4 right-4 w-2 h-2 rounded-full ${profile.availability === 'Available' ? 'bg-emerald-500' : profile.availability === 'Busy' ? 'bg-red-500' : 'bg-amber-500'}`} />

            <div className="flex items-start gap-4 mb-4">
                <div className={`w-14 h-14 rounded-2xl flex items-center justify-center text-lg font-bold text-white shadow-lg ${`bg-${profile.avatarColor}-600`}`}>
                    {profile.avatarInitials}
                </div>
                <div>
                    <h3 className={`text-lg font-semibold text-zinc-100 group-hover:text-white transition-colors ${spaceGrotesk.className}`}>
                        {profile.name}
                    </h3>
                    <p className="text-zinc-500 text-sm">{profile.role}</p>
                    <div className="flex items-center gap-1 mt-1 text-xs text-zinc-600">
                        <MapPin className="w-3 h-3" /> {profile.location}
                    </div>
                </div>
            </div>

            <p className="text-zinc-400 text-sm leading-relaxed mb-6 line-clamp-2 flex-grow">
                {profile.bio}
            </p>

            <div className="flex flex-wrap gap-2 mb-6">
                {profile.skills.slice(0, 3).map(skill => (
                    <span key={skill} className="px-2 py-1 bg-zinc-800/50 border border-zinc-800 rounded-md text-[10px] text-zinc-300">
                        {skill}
                    </span>
                ))}
                {profile.skills.length > 3 && (
                    <span className="px-2 py-1 bg-zinc-800/20 border border-zinc-800 rounded-md text-[10px] text-zinc-500">
                        +{profile.skills.length - 3}
                    </span>
                )}
            </div>

            <div className="mt-auto pt-4 border-t border-zinc-800/50 flex items-center justify-between text-xs">
                <div className="flex items-center gap-1.5 text-zinc-400">
                    <Award className="w-4 h-4 text-yellow-500" />
                    <span className="font-semibold text-zinc-300">{profile.reputation}</span> Rep
                </div>
                <div className="flex items-center gap-1.5 text-zinc-400">
                    <Zap className="w-4 h-4 text-blue-500" />
                    <span className="font-semibold text-zinc-300">{profile.missionsCompleted}</span> Missions
                </div>
            </div>
        </div>
    );
}

// --- Constants ---
const COLOR_MAP: Record<string, { bg: string, gradient: string, solid: string }> = {
    'indigo': { bg: 'bg-indigo-600', gradient: 'from-indigo-900/40', solid: 'bg-indigo-600' },
    'pink': { bg: 'bg-pink-600', gradient: 'from-pink-900/40', solid: 'bg-pink-600' },
    'emerald': { bg: 'bg-emerald-600', gradient: 'from-emerald-900/40', solid: 'bg-emerald-600' },
    'amber': { bg: 'bg-amber-600', gradient: 'from-amber-900/40', solid: 'bg-amber-600' },
    'blue': { bg: 'bg-blue-600', gradient: 'from-blue-900/40', solid: 'bg-blue-600' },
    'purple': { bg: 'bg-purple-600', gradient: 'from-purple-900/40', solid: 'bg-purple-600' },
};

function TalentDetailDrawer({ profile, onClose, onMessage }: { profile: TalentProfile | null, onClose: () => void, onMessage: () => void }) {
    if (!profile) return null;

    const colors = COLOR_MAP[profile.avatarColor] || COLOR_MAP['indigo'];

    return (
        <div className="fixed inset-0 z-[100] flex justify-end bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
            <div className="w-full max-w-2xl h-full bg-[#09090b] border-l border-zinc-800 shadow-2xl overflow-y-auto animate-in slide-in-from-right duration-300 flex flex-col relative">

                {/* Header Image / Pattern */}
                <div className={`h-48 w-full bg-gradient-to-r ${colors.gradient} to-black relative shrink-0`}>
                    <button
                        onClick={onClose}
                        className="absolute top-6 right-6 p-2 bg-black/20 hover:bg-black/40 backdrop-blur-md rounded-full text-white transition-colors z-10"
                    >
                        <ExternalLink className="w-5 h-5 rotate-180" />
                    </button>
                    {/* Decorative pattern overlay */}
                    <div className="absolute inset-0 opacity-20 bg-[url('https://grainy-gradients.vercel.app/noise.svg')] mix-blend-overlay"></div>
                </div>

                <div className="px-8 -mt-20 flex-1 flex flex-col pb-12 relative z-0">
                    {/* Profile Header */}
                    <div className="flex justify-between items-end mb-6">
                        <div className={`w-36 h-36 rounded-3xl flex items-center justify-center text-4xl font-bold text-white shadow-2xl border-[6px] border-[#09090b] ${colors.solid} relative z-10`}>
                            {profile.avatarInitials}
                        </div>
                        <div className="flex gap-3 mb-3 relative z-10">
                            <a href="#" className="p-3 rounded-xl bg-zinc-800/80 hover:bg-zinc-800 text-zinc-400 hover:text-white transition-colors border border-zinc-700/50">
                                <Github className="w-5 h-5" />
                            </a>
                            <a href="#" className="p-3 rounded-xl bg-zinc-800/80 hover:bg-zinc-800 text-zinc-400 hover:text-blue-400 transition-colors border border-zinc-700/50">
                                <Linkedin className="w-5 h-5" />
                            </a>
                            <a href="#" className="p-3 rounded-xl bg-zinc-800/80 hover:bg-zinc-800 text-zinc-400 hover:text-sky-400 transition-colors border border-zinc-700/50">
                                <Twitter className="w-5 h-5" />
                            </a>
                        </div>
                    </div>

                    <div className="mb-8">
                        <div className="flex items-center gap-3 mb-2 flex-wrap">
                            <h2 className={`text-4xl font-bold text-white ${spaceGrotesk.className}`}>{profile.name}</h2>
                            <span className={`px-3 py-1 rounded-full text-xs font-medium border ${profile.availability === 'Available' ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20' :
                                profile.availability === 'Busy' ? 'bg-red-500/10 text-red-400 border-red-500/20' :
                                    'bg-amber-500/10 text-amber-400 border-amber-500/20'
                                }`}>
                                {profile.availability}
                            </span>
                        </div>
                        <p className="text-xl text-zinc-400 font-light">{profile.role}</p>
                        <div className="flex items-center gap-2 mt-2 text-zinc-500 text-sm">
                            <MapPin className="w-4 h-4" /> {profile.location}
                        </div>
                    </div>

                    <div className="grid grid-cols-3 gap-4 mb-10">
                        <div className="bg-zinc-900/50 border border-zinc-800 rounded-2xl p-4 flex flex-col items-center justify-center text-center hover:bg-zinc-800/50 transition-colors">
                            <div className="text-2xl font-bold text-white mb-1">{profile.reputation}</div>
                            <div className="text-[10px] text-zinc-500 uppercase tracking-widest font-semibold">Reputation</div>
                        </div>
                        <div className="bg-zinc-900/50 border border-zinc-800 rounded-2xl p-4 flex flex-col items-center justify-center text-center hover:bg-zinc-800/50 transition-colors">
                            <div className="text-2xl font-bold text-white mb-1">{profile.missionsCompleted}</div>
                            <div className="text-[10px] text-zinc-500 uppercase tracking-widest font-semibold">Missions</div>
                        </div>
                        <div className="bg-zinc-900/50 border border-zinc-800 rounded-2xl p-4 flex flex-col items-center justify-center text-center hover:bg-zinc-800/50 transition-colors">
                            <div className="text-2xl font-bold text-white mb-1">Top 5%</div>
                            <div className="text-[10px] text-zinc-500 uppercase tracking-widest font-semibold">Ranking</div>
                        </div>
                    </div>

                    <div className="space-y-10 mb-8">
                        <div>
                            <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-4 flex items-center gap-2">
                                <Star className="w-4 h-4 text-zinc-600" /> About
                            </h3>
                            <p className="text-zinc-300 leading-relaxed text-sm bg-zinc-900/20 p-4 rounded-xl border border-zinc-800/50">
                                {profile.bio}
                            </p>
                        </div>

                        <div>
                            <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-4 flex items-center gap-2">
                                <Cpu className="w-4 h-4 text-zinc-600" /> Skills
                            </h3>
                            <div className="flex flex-wrap gap-2">
                                {profile.skills.map(skill => (
                                    <span key={skill} className="px-3 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-sm text-zinc-300 hover:text-white hover:border-zinc-700 transition-colors cursor-default">
                                        {skill}
                                    </span>
                                ))}
                            </div>
                        </div>

                        <div>
                            <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-4 flex items-center gap-2">
                                <Code2 className="w-4 h-4 text-zinc-600" /> Recent Contributions
                            </h3>
                            <div className="space-y-3">
                                {profile.recentWork.map((work, i) => (
                                    <div key={i} className="flex items-center gap-4 p-4 bg-zinc-900/30 border border-zinc-800 rounded-xl hover:bg-zinc-900/50 transition-colors cursor-pointer group">
                                        <div className="w-10 h-10 rounded-lg bg-zinc-800 flex items-center justify-center text-zinc-500 group-hover:text-white transition-colors">
                                            <Code2 className="w-5 h-5" />
                                        </div>
                                        <div className="flex-1">
                                            <h4 className="text-sm font-medium text-zinc-300 group-hover:text-white transition-colors">{work}</h4>
                                            <p className="text-xs text-zinc-500">Contributed via DevApp</p>
                                        </div>
                                        <ExternalLink className="w-4 h-4 text-zinc-600 group-hover:text-zinc-400" />
                                    </div>
                                ))}
                            </div>
                        </div>
                    </div>

                    <div className="mt-auto pt-6 border-t border-zinc-800 sticky bottom-0 bg-[#09090b] pb-4">
                        <button
                            onClick={onMessage}
                            className="w-full py-4 bg-white hover:bg-zinc-200 text-black font-bold rounded-xl transition-all shadow-lg hover:shadow-xl hover:scale-[1.01] active:scale-[0.99] flex items-center justify-center gap-2"
                        >
                            <MessageSquare className="w-5 h-5" /> Message {profile.name.split(' ')[0]}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}

// --- Main Discover View ---

export function DiscoverView({ onMessageRedirect }: { onMessageRedirect?: (user: { name: string, role: string, dropId: string }) => void }) {
    const [searchQuery, setSearchQuery] = useState("");
    const [selectedCategory, setSelectedCategory] = useState<RoleCategory>('All');
    const [selectedProfile, setSelectedProfile] = useState<TalentProfile | null>(null);

    const filteredTalent = useMemo(() => {
        return MOCK_TALENT.filter(profile => {
            const matchesSearch = profile.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                profile.skills.some(skill => skill.toLowerCase().includes(searchQuery.toLowerCase()));
            const matchesCategory = selectedCategory === 'All' || profile.category === selectedCategory;
            return matchesSearch && matchesCategory;
        });
    }, [searchQuery, selectedCategory]);

    const categories: { id: RoleCategory, icon: React.ReactNode }[] = [
        { id: 'All', icon: <Globe className="w-4 h-4" /> },
        { id: 'Developer', icon: <Terminal className="w-4 h-4" /> },
        { id: 'Designer', icon: <Palette className="w-4 h-4" /> },
        { id: 'Product Manager', icon: <Layout className="w-4 h-4" /> },
        { id: 'Data Scientist', icon: <Database className="w-4 h-4" /> },
    ];

    const handleMessageClick = () => {
        if (!selectedProfile || !onMessageRedirect) return;

        onMessageRedirect({
            name: selectedProfile.name,
            role: selectedProfile.role, // Use their actual role for context
            dropId: 'general_inquiry' // Or some identifier for a direct message
        });
        setSelectedProfile(null); // Close the drawer
    };

    return (
        <div className="flex-1 p-8 lg:p-12 pt-32 animate-in fade-in duration-500 relative min-h-screen">

            <TalentDetailDrawer
                profile={selectedProfile}
                onClose={() => setSelectedProfile(null)}
                onMessage={handleMessageClick}
            />

            <div className="max-w-7xl mx-auto space-y-8">

                {/* Header */}
                <div className="flex flex-col md:flex-row md:items-end justify-between gap-6">
                    <div>
                        <h2 className={`text-3xl font-light text-zinc-100 ${spaceGrotesk.className}`}>Discover Talent</h2>
                        <p className="text-zinc-500 mt-1 max-w-lg">Find the perfect experts for your missions. Browse by role, skills, or reputation.</p>
                    </div>

                    <div className="w-full md:w-auto relative">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
                        <input
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            placeholder="Search by name or skill..."
                            className="w-full md:w-80 pl-10 pr-4 py-2.5 bg-[#09090b] border border-zinc-800 rounded-xl text-sm text-zinc-200 focus:outline-none focus:border-zinc-600 transition-colors"
                        />
                    </div>
                </div>

                {/* Categories */}
                <div className="flex flex-wrap gap-2 pb-4 border-b border-zinc-800/50">
                    {categories.map(cat => (
                        <button
                            key={cat.id}
                            onClick={() => setSelectedCategory(cat.id)}
                            className={`px-4 py-2 rounded-full text-xs font-medium border flex items-center gap-2 transition-all ${selectedCategory === cat.id
                                ? 'bg-white text-black border-white'
                                : 'bg-transparent text-zinc-400 border-zinc-800 hover:border-zinc-600 hover:text-zinc-200'
                                }`}
                        >
                            {cat.icon}
                            {cat.id}
                        </button>
                    ))}
                </div>

                {/* Grid */}
                {filteredTalent.length > 0 ? (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        {filteredTalent.map(profile => (
                            <ProfileCard
                                key={profile.id}
                                profile={profile}
                                onClick={() => setSelectedProfile(profile)}
                            />
                        ))}
                    </div>
                ) : (
                    <div className="flex flex-col items-center justify-center py-20 text-zinc-500">
                        <div className="w-16 h-16 rounded-full bg-zinc-900 flex items-center justify-center mb-4">
                            <Search className="w-8 h-8 opacity-50" />
                        </div>
                        <p className="text-lg font-medium text-zinc-400">No profiles found</p>
                        <p className="text-sm">Try adjusting your filters or search query.</p>
                    </div>
                )}
            </div>
        </div>
    );
}
