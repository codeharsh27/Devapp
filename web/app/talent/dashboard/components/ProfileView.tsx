
"use client";
import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { PageLoader } from "@/components/ui/PageLoader";
import { ArrowLeft, MessageSquare, ExternalLink, Award, Code2, Zap, Layout, ShieldCheck, Lock, Share2 } from "lucide-react";
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
        <div className="max-w-4xl mx-auto p-8 text-white animate-in fade-in duration-500">
            <ProofOfWorkModal submission={selectedSubmission} onClose={() => setSelectedSubmission(null)} />

            <h1 className="text-3xl font-light mb-8">Profile</h1>

            <div className="bg-[#111113] border border-zinc-800 rounded-2xl p-8">
                {isEditing ? (
                    <div className="space-y-6 max-w-xl">
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-xs text-zinc-500 uppercase tracking-wide mb-1">Full Name</label>
                                <input value={form.full_name} onChange={e => setForm({ ...form, full_name: e.target.value })} className="w-full bg-black border border-zinc-800 p-2 rounded text-white focus:border-indigo-500 outline-none" />
                            </div>
                            <div>
                                <label className="block text-xs text-zinc-500 uppercase tracking-wide mb-1">Portfolio / Website</label>
                                <input value={form.website} onChange={e => setForm({ ...form, website: e.target.value })} className="w-full bg-black border border-zinc-800 p-2 rounded text-white focus:border-indigo-500 outline-none" />
                            </div>
                        </div>

                        <div>
                            <label className="block text-xs text-zinc-500 uppercase tracking-wide mb-1">Bio</label>
                            <textarea value={form.bio} onChange={e => setForm({ ...form, bio: e.target.value })} className="w-full bg-black border border-zinc-800 p-2 rounded text-white focus:border-indigo-500 outline-none h-24" />
                        </div>

                        <div>
                            <label className="block text-xs text-zinc-500 uppercase tracking-wide mb-1">Skills (comma separated)</label>
                            <input
                                value={form.skills.join(', ')}
                                onChange={handleSkillsChange}
                                className="w-full bg-black border border-zinc-800 p-2 rounded text-white focus:border-indigo-500 outline-none"
                                placeholder="React, Node.js, TypeScript..."
                            />
                        </div>

                        <div className="flex gap-4 pt-4 border-t border-zinc-800">
                            <button onClick={saveProfile} className="bg-white text-black px-6 py-2 rounded-lg font-bold hover:bg-zinc-200 transition-colors">Save Changes</button>
                            <button onClick={() => setIsEditing(false)} className="text-zinc-500 px-4 py-2 hover:text-white transition-colors">Cancel</button>
                        </div>
                    </div>
                ) : (
                    <div>
                        <div className="flex items-start justify-between mb-8">
                            <div className="flex items-center gap-6">
                                <div className="w-24 h-24 rounded-full bg-indigo-600 flex items-center justify-center text-3xl font-bold text-white uppercase shadow-lg shadow-indigo-500/20 relative">
                                    {profile?.full_name?.substring(0, 2) || 'ME'}
                                    {profile?.subscription_tier === 'pro' && (
                                        <div className="absolute -bottom-2 -right-2 bg-amber-500 text-black p-1.5 rounded-full border-2 border-[#111] shadow-lg" title="Founding Member">
                                            <Award className="w-4 h-4" />
                                        </div>
                                    )}
                                </div>
                                <div>
                                    <div className="flex items-center gap-2 mb-1">
                                        <h2 className="text-3xl font-bold text-white">{profile?.full_name || 'No Name Set'}</h2>
                                        {profile?.subscription_tier === 'pro' && (
                                            <span className="bg-amber-500/10 text-amber-500 border border-amber-500/20 px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wide flex items-center gap-1">
                                                <Award className="w-3 h-3" /> Pro Member
                                            </span>
                                        )}
                                    </div>
                                    <p className="text-zinc-500 text-sm mb-4">{profile?.email}</p>

                                    <div className="flex gap-2 items-center">
                                        {profile?.website && (
                                            <a href={profile.website} target="_blank" rel="noopener noreferrer" className="text-xs bg-zinc-800 text-zinc-300 px-3 py-1 rounded-full hover:bg-zinc-700 transition-colors">
                                                {profile.website}
                                            </a>
                                        )}
                                        <div className="text-xs bg-emerald-500/10 text-emerald-400 px-3 py-1 rounded-full border border-emerald-500/20">
                                            Available for work
                                        </div>

                                        {profile?.subscription_tier !== 'pro' && (
                                            <button
                                                onClick={handleUpgrade}
                                                disabled={isUpgrading}
                                                className="ml-2 text-xs bg-indigo-600 hover:bg-indigo-500 text-white px-3 py-1 rounded-full border border-indigo-500/20 transition-all flex items-center gap-1 animate-pulse font-bold"
                                            >
                                                {isUpgrading ? "Upgrading..." : "Claim Founding Member Status (Free)"}
                                            </button>
                                        )}
                                    </div>
                                </div>
                            </div>
                            <button onClick={() => setIsEditing(true)} className="px-5 py-2 border border-zinc-700 rounded-lg text-sm hover:bg-zinc-800 transition-colors bg-zinc-900 font-medium">Edit Profile</button>
                        </div>

                        <div className="border-t border-zinc-800 pt-8 grid lg:grid-cols-3 gap-8">
                            <div className="lg:col-span-2 space-y-8">
                                <div>
                                    <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-3">About</h3>
                                    <p className="text-zinc-300 leading-relaxed text-sm">
                                        {profile?.bio || "No bio added yet. Tell startups about yourself!"}
                                    </p>
                                </div>

                                <div>
                                    <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-3">Skills</h3>
                                    {profile?.skills && profile.skills.length > 0 ? (
                                        <div className="flex flex-wrap gap-2">
                                            {profile.skills.map((s: string, i: number) => (
                                                <span key={i} className="px-3 py-1 bg-zinc-900 border border-zinc-800 rounded-md text-sm text-zinc-300">
                                                    {s}
                                                </span>
                                            ))}
                                        </div>
                                    ) : (
                                        <span className="text-zinc-600 text-sm italic">No skills listed.</span>
                                    )}
                                </div>
                            </div>

                            {/* Completed Tasks Column */}
                            <div>
                                <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-3">Completed Tasks</h3>
                                <div className="space-y-2">
                                    {completedTasks.length > 0 ? (
                                        // @ts-ignore
                                        completedTasks.map((task) => (
                                            <div key={task.id} className="bg-zinc-900/50 border border-zinc-800 p-3 rounded-lg hover:border-zinc-700 transition-colors group">
                                                <div className="text-sm font-bold text-zinc-200">{task.task.title}</div>
                                                <div className="flex justify-between items-center mt-2">
                                                    <span className="text-[10px] text-zinc-500 uppercase">{task.task.startup?.full_name}</span>
                                                    <div className="flex items-center gap-2">
                                                        <span className="text-emerald-400 font-mono text-xs font-bold">{task.final_score}/100</span>
                                                        <button
                                                            onClick={() => setSelectedSubmission(task)}
                                                            className="p-1 hover:bg-white hover:text-black rounded transition-colors text-zinc-500"
                                                            title="Share Proof of Work"
                                                        >
                                                            <Share2 className="w-3 h-3" />
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        ))
                                    ) : (
                                        <div className="text-zinc-600 text-xs italic border border-dashed border-zinc-800 p-4 rounded text-center">
                                            No completed tasks yet.
                                        </div>
                                    )}
                                </div>
                            </div>
                        </div>
                    </div>
                )}
            </div>

            {/* Future: Stats or Portfolio here */}
        </div>
    );
}
