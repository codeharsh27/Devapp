"use client";
import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { PageLoader } from "@/components/ui/PageLoader";
import { Share2, Award, ExternalLink, Layout, Code2, ShieldCheck, Zap, Lock } from "lucide-react";
import { ProofOfWorkModal } from "./ProofOfWorkModal";

export function ProfileView({ userId }: { userId: string | undefined }) {
    const [profile, setProfile] = useState<any>(null);
    const [loading, setLoading] = useState(true);
    const [isEditing, setIsEditing] = useState(false);
    const [isUpgrading, setIsUpgrading] = useState(false);
    const [selectedSubmission, setSelectedSubmission] = useState<any | null>(null);

    // Edit Form
    const [form, setForm] = useState({
        full_name: '',
        bio: '',
        website: '',
        skills: [] as string[]
    });

    const [completedTasks, setCompletedTasks] = useState<any[]>([]);

    useEffect(() => {
        if (!userId) return;
        const fetchProfile = async () => {
            const supabase = createClient();
            const { data } = await supabase.from('profiles').select('*').eq('id', userId).single();
            if (data) {
                setProfile(data);
                setForm({
                    full_name: data.full_name || '',
                    bio: data.bio || '',
                    website: data.website || '',
                    skills: data.skills || []
                });
            }

            // Fetch Completed Tasks
            const { data: completed } = await supabase
                .from('submissions')
                .select(`
                    id, final_score, created_at,
                    task:tasks(title, category, startup:profiles(full_name))
                `)
                .eq('developer_id', userId)
                .eq('status', 'evaluated')
                .order('created_at', { ascending: false });

            if (completed) setCompletedTasks(completed);

            setLoading(false);
        };
        fetchProfile();
    }, [userId]);

    const saveProfile = async () => {
        const supabase = createClient();
        await supabase.from('profiles').update(form).eq('id', userId);
        setIsEditing(false);
        // Refresh
        setProfile({ ...profile, ...form });
    };

    const handleUpgrade = async () => {
        setIsUpgrading(true);
        const supabase = createClient();
        await supabase.from('profiles').update({ subscription_tier: 'pro' }).eq('id', userId);
        setProfile({ ...profile, subscription_tier: 'pro' });
        setIsUpgrading(false);
        alert("Welcome to DevApp Pro (Founding Member)!");
    };

    const handleSkillsChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const val = e.target.value;
        const skillsArray = val.split(',').map(s => s.trim()).filter(s => s.length > 0);
        setForm(prev => ({ ...prev, skills: skillsArray }));
    };

    if (loading) return <PageLoader />;

    return (
        <div className="max-w-5xl mx-auto p-8 text-white animate-in fade-in duration-500 space-y-8 pb-32">
            <ProofOfWorkModal submission={selectedSubmission} onClose={() => setSelectedSubmission(null)} />

            <div className="flex items-center justify-between mb-4">
                <h1 className="text-3xl font-light">Developer Profile</h1>
                {!isEditing && (
                    <button onClick={() => setIsEditing(true)} className="px-5 py-2 border border-zinc-700/50 rounded-xl text-sm hover:bg-zinc-800 transition-colors bg-zinc-900/50 font-medium tracking-wide flex items-center gap-2 shadow-sm">
                        Edit Profile
                    </button>
                )}
            </div>

            {/* Profile Info Card */}
            <div className="relative overflow-hidden rounded-3xl border border-zinc-800/60 bg-gradient-to-br from-[#111113] via-[#0c0c0e] to-[#111113] p-10 shadow-2xl">
                {/* Decorative glow */}
                <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-indigo-500/10 rounded-full blur-[100px] pointer-events-none -mr-40 -mt-40" />
                <div className="absolute bottom-0 left-0 w-72 h-72 bg-emerald-500/5 rounded-full blur-[80px] pointer-events-none -ml-20 -mb-20" />

                <div className="relative z-10">
                    {isEditing ? (
                        <div className="space-y-8 max-w-2xl bg-black/40 p-6 rounded-2xl border border-zinc-800/50 backdrop-blur-sm">
                            <h3 className="text-lg font-medium border-b border-zinc-800/50 pb-3">Edit Details</h3>
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label className="block text-xs text-zinc-500 uppercase tracking-widest mb-2 font-bold">Full Name</label>
                                    <input value={form.full_name} onChange={e => setForm({ ...form, full_name: e.target.value })} className="w-full bg-[#0c0c0e] border border-zinc-800 p-3 rounded-xl text-white focus:border-indigo-500 outline-none transition-colors" />
                                </div>
                                <div>
                                    <label className="block text-xs text-zinc-500 uppercase tracking-widest mb-2 font-bold">Portfolio / Website</label>
                                    <input value={form.website} onChange={e => setForm({ ...form, website: e.target.value })} className="w-full bg-[#0c0c0e] border border-zinc-800 p-3 rounded-xl text-white focus:border-indigo-500 outline-none transition-colors" placeholder="https://" />
                                </div>
                            </div>

                            <div>
                                <label className="block text-xs text-zinc-500 uppercase tracking-widest mb-2 font-bold">Bio</label>
                                <textarea value={form.bio} onChange={e => setForm({ ...form, bio: e.target.value })} className="w-full bg-[#0c0c0e] border border-zinc-800 p-3 rounded-xl text-white focus:border-indigo-500 outline-none h-28 resize-none transition-colors" placeholder="Tell startups about your engineering focus..." />
                            </div>

                            <div>
                                <label className="block text-xs text-zinc-500 uppercase tracking-widest mb-2 font-bold">Skills (comma separated)</label>
                                <input
                                    value={form.skills.join(', ')}
                                    onChange={handleSkillsChange}
                                    className="w-full bg-[#0c0c0e] border border-zinc-800 p-3 rounded-xl text-white focus:border-indigo-500 outline-none transition-colors"
                                    placeholder="React, Node.js, TypeScript, Go..."
                                />
                                <p className="text-[10px] text-zinc-500 mt-2">These skills will be highlighted to founders.</p>
                            </div>

                            <div className="flex gap-4 pt-4">
                                <button onClick={saveProfile} className="bg-white text-black px-8 py-3 rounded-xl font-bold hover:bg-zinc-200 transition-colors shadow-lg">Save Changes</button>
                                <button onClick={() => setIsEditing(false)} className="text-zinc-500 px-6 py-3 hover:text-white transition-colors font-medium">Cancel</button>
                            </div>
                        </div>
                    ) : (
                        <div className="flex flex-col md:flex-row items-start gap-10">
                            {/* Avatar Section */}
                            <div className="flex flex-col items-center gap-4 shrink-0">
                                <div className="w-32 h-32 rounded-3xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center text-4xl font-bold text-white uppercase shadow-[0_0_40px_-10px_rgba(99,102,241,0.5)] relative transform hover:scale-105 transition-transform duration-300">
                                    {profile?.full_name?.substring(0, 2) || 'ME'}
                                    {profile?.subscription_tier === 'pro' && (
                                        <div className="absolute -bottom-3 -right-3 bg-gradient-to-r from-amber-400 to-amber-600 text-black p-2 rounded-xl shadow-xl flex items-center justify-center border-2 border-[#111113] transform rotate-3" title="Founding Member">
                                            <Award className="w-5 h-5" />
                                        </div>
                                    )}
                                </div>

                                {profile?.subscription_tier !== 'pro' && (
                                    <button
                                        onClick={handleUpgrade}
                                        disabled={isUpgrading}
                                        className="text-xs w-full bg-white/5 hover:bg-white/10 text-zinc-300 px-4 py-2 rounded-xl border border-white/10 transition-all font-medium whitespace-nowrap"
                                    >
                                        {isUpgrading ? "Upgrading..." : "Claim Full Access 🚀"}
                                    </button>
                                )}
                            </div>

                            {/* Info Section */}
                            <div className="flex-1 space-y-6">
                                <div>
                                    <h2 className="text-4xl font-semibold text-white tracking-tight mb-2 flex items-center gap-3">
                                        {profile?.full_name || 'No Name Set'}
                                        {profile?.subscription_tier === 'pro' && (
                                            <span className="bg-amber-500/10 text-amber-500 border border-amber-500/20 px-2.5 py-1 rounded-lg text-[10px] font-bold uppercase tracking-widest flex items-center gap-1.5 backdrop-blur-md">
                                                <Award className="w-3.5 h-3.5" /> Pro
                                            </span>
                                        )}
                                        <div className="text-xs bg-emerald-500/10 text-emerald-400 px-2.5 py-1 rounded-lg border border-emerald-500/20 font-medium tracking-wide">
                                            Available Space
                                        </div>
                                    </h2>
                                    <p className="text-zinc-400 text-sm">{profile?.email}</p>
                                </div>

                                <div className="flex flex-wrap gap-3">
                                    {profile?.website && (
                                        <a href={profile.website} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1.5 text-xs font-mono bg-zinc-800/50 text-zinc-300 px-4 py-2 rounded-xl hover:bg-zinc-700 transition-colors border border-zinc-700/50 shadow-sm">
                                            <ExternalLink className="w-3.5 h-3.5" />
                                            {profile.website}
                                        </a>
                                    )}
                                </div>

                                <div className="bg-black/30 p-6 rounded-2xl border border-zinc-800/40">
                                    <h3 className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest mb-3 flex items-center gap-2">
                                        <Layout className="w-3.5 h-3.5" /> About
                                    </h3>
                                    <p className="text-zinc-300 leading-relaxed text-sm">
                                        {profile?.bio || "No bio added yet. Tell startups about your expertise and what you love building!"}
                                    </p>
                                </div>

                                <div>
                                    <h3 className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest mb-3 flex items-center gap-2">
                                        <Code2 className="w-3.5 h-3.5" /> Arsenal Core
                                    </h3>
                                    {profile?.skills && profile.skills.length > 0 ? (
                                        <div className="flex flex-wrap gap-2">
                                            {profile.skills.map((s: string, i: number) => (
                                                <span key={i} className="px-3.5 py-1.5 bg-indigo-500/10 border border-indigo-500/20 rounded-lg text-xs font-mono text-indigo-300 shadow-sm backdrop-blur-sm hover:bg-indigo-500/20 transition-colors cursor-default">
                                                    {s}
                                                </span>
                                            ))}
                                        </div>
                                    ) : (
                                        <span className="text-zinc-500 text-sm italic bg-zinc-900/50 px-4 py-2 rounded-lg border border-dashed border-zinc-800 block w-max">
                                            No skills listed. Setup your node to show startups your tech stack.
                                        </span>
                                    )}
                                </div>
                            </div>
                        </div>
                    )}
                </div>
            </div>

            {/* Completed Tasks Full Width Section */}
            {!isEditing && (
                <div className="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-700 delay-100">
                    <div className="flex items-center gap-3 border-b border-zinc-800 pb-4">
                        <div className="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center">
                            <ShieldCheck className="w-4 h-4 text-emerald-400" />
                        </div>
                        <div>
                            <h3 className="text-lg font-bold text-white tracking-tight">Proof of Work</h3>
                            <p className="text-xs text-zinc-500">Completed missions and successfully evaluated contributions.</p>
                        </div>
                    </div>

                    {completedTasks.length > 0 ? (
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-4">
                            {/* @ts-ignore */}
                            {completedTasks.map((task) => (
                                <div key={task.id} className="relative group bg-[#0c0c0e] border border-zinc-800/60 p-5 rounded-2xl hover:border-emerald-500/40 transition-all overflow-hidden shadow-sm hover:shadow-emerald-500/5">
                                    <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none" />

                                    <div className="relative z-10 flex justify-between items-start gap-4 mb-4">
                                        <div>
                                            <div className="text-[10px] text-emerald-500 uppercase tracking-widest font-bold mb-1 opacity-80">
                                                {task.task.startup?.full_name}
                                            </div>
                                            <h4 className="text-base font-semibold text-zinc-100 group-hover:text-emerald-50 transition-colors leading-tight">
                                                {task.task.title}
                                            </h4>
                                        </div>
                                        <div className="bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 font-mono text-sm font-bold px-3 py-1 rounded-lg flex items-center gap-1.5 shadow-inner">
                                            <Zap className="w-3 h-3" />
                                            {task.final_score}
                                        </div>
                                    </div>

                                    <div className="relative z-10 flex justify-between items-center mt-6 pt-4 border-t border-zinc-800/50">
                                        <span className="text-xs font-mono text-zinc-600 group-hover:text-zinc-400 transition-colors">
                                            {new Date(task.created_at).toLocaleDateString()}
                                        </span>
                                        <button
                                            onClick={() => setSelectedSubmission(task)}
                                            className="px-4 py-2 bg-white/5 hover:bg-white text-zinc-300 hover:text-black rounded-xl text-xs font-bold transition-all flex items-center gap-2 group/btn"
                                            title="View Details & Share"
                                        >
                                            <Share2 className="w-3.5 h-3.5 group-hover/btn:scale-110 transition-transform" />
                                            Share Details
                                        </button>
                                    </div>
                                </div>
                            ))}
                        </div>
                    ) : (
                        <div className="flex flex-col items-center justify-center py-16 px-6 border border-dashed border-zinc-800 rounded-3xl bg-zinc-900/20">
                            <div className="w-16 h-16 rounded-full bg-zinc-800/50 flex items-center justify-center mb-4">
                                <Lock className="w-6 h-6 text-zinc-500" />
                            </div>
                            <h4 className="text-zinc-300 font-medium mb-1">No completed tasks yet</h4>
                            <p className="text-zinc-500 text-sm text-center max-w-sm">
                                Find a mission, submit high quality code, and build your indestructible track record.
                            </p>
                        </div>
                    )}
                </div>
            )}
        </div>
    );
}
