
"use client";
import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { PageLoader } from "@/components/ui/PageLoader";
import { Building2, Globe, MapPin, Mail, Upload } from "lucide-react";

export function ProfileView({ userId }: { userId: string | undefined }) {
    const [profile, setProfile] = useState<any>(null);
    const [loading, setLoading] = useState(true);
    const [isEditing, setIsEditing] = useState(false);

    // Edit Form
    const [form, setForm] = useState({ full_name: '', bio: '', website: '', location: '', company_name: '' });

    useEffect(() => {
        if (!userId) return;
        const fetchProfile = async () => {
            const supabase = createClient();
            const { data } = await supabase.from('profiles').select('*').eq('id', userId).single();
            if (data) {
                setProfile(data);
                // Note: 'company_name' might not be in schema yet, using metadata or full_name for now
                setForm({
                    full_name: data.full_name || '',
                    bio: data.bio || '',
                    website: data.website || '',
                    location: data.location || '', // Check migration if column exists
                    company_name: data.company_name || ''
                });
            }
            setLoading(false);
        };
        fetchProfile();
    }, [userId]);

    const saveProfile = async () => {
        const supabase = createClient();
        // Filter out keys not in valid schema
        const updates = {
            full_name: form.full_name,
            bio: form.bio,
            website: form.website,
            // location: form.location, // Assuming column exists or use metadata
        };

        await supabase.from('profiles').update(updates).eq('id', userId);
        setIsEditing(false);
        setProfile({ ...profile, ...updates });
    };

    if (loading) return <PageLoader />;

    return (
        <div className="max-w-4xl mx-auto p-8 text-white animate-in fade-in duration-500">
            <h1 className="text-3xl font-light mb-8">Company Profile</h1>

            <div className="bg-[#111113] border border-zinc-800 rounded-2xl p-8">
                {isEditing ? (
                    <div className="space-y-6 max-w-lg">
                        <div className="grid grid-cols-2 gap-4">
                            <div className="col-span-2">
                                <label className="block text-xs text-zinc-500 uppercase tracking-wide mb-1">Company Name</label>
                                <input value={form.full_name} onChange={e => setForm({ ...form, full_name: e.target.value })} className="w-full bg-black border border-zinc-800 p-3 rounded-lg text-white outline-none focus:border-indigo-500 transition-colors" />
                            </div>
                            <div className="col-span-2">
                                <label className="block text-xs text-zinc-500 uppercase tracking-wide mb-1">Description</label>
                                <textarea value={form.bio} onChange={e => setForm({ ...form, bio: e.target.value })} className="w-full bg-black border border-zinc-800 p-3 rounded-lg text-white outline-none focus:border-indigo-500 transition-colors h-32" />
                            </div>
                            <div>
                                <label className="block text-xs text-zinc-500 uppercase tracking-wide mb-1">Website</label>
                                <input value={form.website} onChange={e => setForm({ ...form, website: e.target.value })} className="w-full bg-black border border-zinc-800 p-3 rounded-lg text-white outline-none focus:border-indigo-500 transition-colors" />
                            </div>
                        </div>
                        <div className="flex gap-4 pt-4 border-t border-zinc-800">
                            <button onClick={saveProfile} className="bg-white text-black px-6 py-2.5 rounded-lg font-bold hover:bg-zinc-200 transition-colors">Save Changes</button>
                            <button onClick={() => setIsEditing(false)} className="text-zinc-500 px-4 py-2 hover:text-white transition-colors">Cancel</button>
                        </div>
                    </div>
                ) : (
                    <div>
                        <div className="flex items-start justify-between mb-8">
                            <div className="flex items-center gap-6">
                                <div className="w-24 h-24 rounded-2xl bg-indigo-600 flex items-center justify-center text-3xl font-bold text-white uppercase shadow-2xl shadow-indigo-900/20">
                                    {profile?.full_name?.substring(0, 1)}
                                </div>
                                <div>
                                    <h2 className="text-3xl font-bold text-white mb-2">{profile?.full_name}</h2>
                                    <div className="flex items-center gap-4 text-sm text-zinc-500">
                                        {profile?.website && (
                                            <a href={profile.website} target="_blank" className="flex items-center gap-1 hover:text-indigo-400 transition-colors">
                                                <Globe className="w-4 h-4" /> Website
                                            </a>
                                        )}
                                        <span className="flex items-center gap-1"><MapPin className="w-4 h-4" /> San Francisco, CA</span>
                                    </div>
                                </div>
                            </div>
                            <button onClick={() => setIsEditing(true)} className="px-5 py-2.5 border border-zinc-800 rounded-xl text-sm font-bold hover:bg-zinc-800 transition-colors shadow-lg">Edit Profile</button>
                        </div>

                        <div className="grid grid-cols-3 gap-8 border-t border-zinc-800 pt-8">
                            <div className="col-span-2">
                                <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-wider mb-4">About</h3>
                                <p className="text-zinc-400 leading-relaxed text-sm whitespace-pre-wrap">{profile?.bio || "No description provided."}</p>
                            </div>
                            <div>
                                <h3 className="text-xs font-bold text-zinc-500 uppercase tracking-wider mb-4">Details</h3>
                                <div className="space-y-4">
                                    <div>
                                        <span className="block text-zinc-600 text-xs mb-1">Industry</span>
                                        <span className="text-zinc-300 text-sm font-medium">Technology</span>
                                    </div>
                                    <div>
                                        <span className="block text-zinc-600 text-xs mb-1">Team Size</span>
                                        <span className="text-zinc-300 text-sm font-medium">10-50</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
}
