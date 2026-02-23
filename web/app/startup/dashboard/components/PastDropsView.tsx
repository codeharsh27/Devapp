"use client";
import { MoreHorizontal, Users, CheckCircle2, AlertCircle, MessageSquare, ExternalLink, Github, FileText, Pencil, Trash2, ShieldAlert } from "lucide-react";
import { Space_Grotesk } from "next/font/google";
import { useState, useEffect, useTransition } from "react";
import { supabase } from "@/lib/supabaseClient";
import { deleteMission, updateMissionStatus } from "@/app/actions/startupMissions";
import { toast } from "sonner"; // Assuming sonner or we can just use simple state

const spaceGrotesk = Space_Grotesk({ subsets: ["latin"], weight: ["300", "400", "500"] });

type DropStatus = 'open' | 'in_progress' | 'completed' | 'cancelled';

interface Profile {
    id: string;
    full_name: string;
    avatar_url: string;
}

interface Submission {
    id: string;
    status: string;
    developer: Profile;
    final_score?: number;
    github_url?: string;
    live_url?: string;
}

interface Drop {
    id: string;
    title: string;
    category: string;
    status: DropStatus;
    created_at: string;
    updated_at: string;
    bounty: number;
    description: string;
    applicantsCount: number;
    submissionsCount: number;
    submissions: Submission[];
}

function StatusBadge({ status }: { status: DropStatus | string }) {
    const s = status.toLowerCase();
    const styles: Record<string, string> = {
        'open': 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20',
        'in_progress': 'bg-blue-500/10 text-blue-400 border-blue-500/20',
        'completed': 'bg-purple-500/10 text-purple-400 border-purple-500/20',
        'cancelled': 'bg-red-500/10 text-red-400 border-red-500/20',
    };

    const icons: Record<string, React.ReactNode> = {
        'open': <Users className="w-3 h-3" />,
        'in_progress': <AlertCircle className="w-3 h-3" />,
        'completed': <CheckCircle2 className="w-3 h-3" />,
        'cancelled': <ShieldAlert className="w-3 h-3" />
    };

    return (
        <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-medium border uppercase tracking-wider ${styles[s] || styles['open']}`}>
            {icons[s] || icons['open']}
            {s.replace('_', ' ')}
        </span>
    );
}

function MissionDrawer({ drop, onClose, onRefresh }: { drop: Drop | null, onClose: () => void, onRefresh: () => void }) {
    const [isPending, startTransition] = useTransition();

    if (!drop) return null;

    const topSubmissions = drop.submissions
        .filter(s => s.status !== 'enrolled')
        .sort((a, b) => (b.final_score || 0) - (a.final_score || 0));

    const handleUpdateStatus = (newStatus: string) => {
        startTransition(async () => {
            const res = await updateMissionStatus(drop.id, newStatus);
            if (res.error) {
                toast.error(res.error);
            } else {
                toast.success("Mission updated successfully");
                onRefresh();
            }
        });
    };

    return (
        <div className="fixed inset-0 z-50 flex justify-end bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
            {/* Backdrop click */}
            <div className="absolute inset-0" onClick={onClose} />

            <div className="relative w-full max-w-2xl h-full bg-[#0c0c0e] border-l border-zinc-800 shadow-2xl overflow-y-auto animate-in slide-in-from-right duration-300 p-8 flex flex-col">
                <div className="flex items-start justify-between mb-8">
                    <div>
                        <div className="flex items-center gap-3 mb-3">
                            <StatusBadge status={drop.status} />
                            <span className="text-xs text-zinc-500 font-mono">${drop.bounty} USDC</span>
                        </div>
                        <h2 className={`text-3xl font-light text-white tracking-tight ${spaceGrotesk.className}`}>{drop.title}</h2>
                    </div>
                </div>

                <div className="space-y-8 flex-1">
                    <div className="bg-zinc-900/40 border border-zinc-800/50 p-5 rounded-2xl">
                        <h4 className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest mb-2 flex items-center gap-2">
                            <FileText className="w-3.5 h-3.5" /> Brief
                        </h4>
                        <p className="text-zinc-300 text-sm leading-relaxed whitespace-pre-wrap">{drop.description}</p>
                    </div>

                    <div>
                        <h4 className="text-[10px] font-bold text-zinc-500 uppercase tracking-widest mb-4 flex items-center gap-2">
                            <Users className="w-3.5 h-3.5" /> Top Submissions ({topSubmissions.length})
                        </h4>

                        <div className="space-y-3">
                            {topSubmissions.length > 0 ? topSubmissions.map((sub, idx) => (
                                <div key={sub.id} className="bg-zinc-900/40 p-4 rounded-xl border border-zinc-800/50 flex items-center justify-between group hover:border-zinc-700 transition-colors">
                                    <div className="flex items-center gap-4">
                                        <div className="w-10 h-10 rounded-full bg-indigo-500/20 text-indigo-400 font-bold flex items-center justify-center text-sm border border-indigo-500/30">
                                            {sub.developer?.full_name?.substring(0, 2).toUpperCase() || 'DV'}
                                        </div>
                                        <div>
                                            <div className="font-medium text-zinc-200">{sub.developer?.full_name || 'Anonymous'}</div>
                                            <div className="text-xs text-zinc-500 uppercase tracking-wider">{sub.status}</div>
                                        </div>
                                    </div>
                                    <div className="flex items-center gap-4">
                                        {sub.final_score && (
                                            <div className="text-emerald-400 font-mono font-bold">{sub.final_score}/100</div>
                                        )}
                                        {sub.github_url && (
                                            <a href={sub.github_url} target="_blank" rel="noreferrer" className="p-2 text-zinc-500 hover:text-white hover:bg-zinc-800 rounded-lg transition-colors">
                                                <Github className="w-4 h-4" />
                                            </a>
                                        )}
                                    </div>
                                </div>
                            )) : (
                                <div className="text-center py-10 bg-zinc-900/20 border border-dashed border-zinc-800 rounded-2xl">
                                    <span className="text-zinc-500 text-sm">No evaluated submissions yet.</span>
                                </div>
                            )}
                        </div>
                    </div>
                </div>

                <div className="pt-6 border-t border-zinc-800 mt-8 flex gap-3">
                    <button onClick={onClose} className="px-5 py-2.5 rounded-xl border border-zinc-700 hover:bg-zinc-800 text-zinc-300 transition-colors text-sm font-medium flex-1">
                        Close
                    </button>
                    {drop.status !== 'completed' && (
                        <button
                            disabled={isPending}
                            onClick={() => handleUpdateStatus('completed')}
                            className="px-5 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white transition-colors text-sm font-bold flex-1 disabled:opacity-50"
                        >
                            {isPending ? "Updating..." : "Mark Completed"}
                        </button>
                    )}
                </div>
            </div>
        </div>
    );
}

export function PastDropsView() {
    const [drops, setDrops] = useState<Drop[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedDrop, setSelectedDrop] = useState<Drop | null>(null);
    const [actionMenuOpen, setActionMenuOpen] = useState<string | null>(null);
    const [isPending, startTransition] = useTransition();

    const fetchMissions = async () => {
        setLoading(true);
        const { data: { session } } = await supabase.auth.getSession();
        if (!session) return;

        // Fetch tasks with submissions
        const { data, error } = await supabase
            .from('tasks')
            .select(`
                *,
                submissions (
                    id,
                    status,
                    final_score,
                    github_url,
                    developer_id,
                    developer:profiles!submissions_developer_id_fkey(id, full_name, avatar_url)
                )
            `)
            .eq('startup_id', session.user.id)
            .order('created_at', { ascending: false });

        if (data && !error) {
            const mapped: Drop[] = data.map((t: any) => {
                const subs = t.submissions || [];
                const applicants = subs.filter((s: any) => s.status === 'enrolled').length;
                const totalSubmissions = subs.filter((s: any) => s.status !== 'enrolled').length;

                return {
                    id: t.id,
                    title: t.title,
                    category: t.category || 'Engineering',
                    status: t.status || 'open',
                    created_at: t.created_at,
                    updated_at: t.updated_at,
                    bounty: t.bounty || 0,
                    description: t.description || '',
                    applicantsCount: applicants,
                    submissionsCount: totalSubmissions,
                    submissions: subs
                };
            });
            setDrops(mapped);
        }
        setLoading(false);
    };

    useEffect(() => {
        fetchMissions();

        const channel = supabase.channel('startup_missions')
            .on('postgres_changes', { event: '*', schema: 'public', table: 'tasks' }, fetchMissions)
            .on('postgres_changes', { event: '*', schema: 'public', table: 'submissions' }, fetchMissions)
            .subscribe();

        return () => { supabase.removeChannel(channel); };
    }, []);

    const handleDelete = (id: string, e: React.MouseEvent) => {
        e.stopPropagation();
        if (!confirm("Are you sure you want to delete this mission?")) return;

        startTransition(async () => {
            const res = await deleteMission(id);
            if (res.error) {
                toast.error(res.error);
            } else {
                toast.success("Mission deleted");
                fetchMissions();
            }
        });
    };

    const handleUpdate = (id: string, newStatus: string, e: React.MouseEvent) => {
        e.stopPropagation();
        startTransition(async () => {
            const res = await updateMissionStatus(id, newStatus);
            if (res.error) {
                toast.error(res.error);
            } else {
                toast.success("Mission updated");
                fetchMissions();
            }
        });
    };

    if (loading) {
        return <div className="p-12 text-zinc-500 animate-pulse text-sm">Loading missions...</div>;
    }

    return (
        <div className="flex-1 p-8 lg:p-12 pt-32 animate-in fade-in duration-500 relative pb-32">
            <MissionDrawer drop={selectedDrop} onClose={() => setSelectedDrop(null)} onRefresh={fetchMissions} />

            <div className="max-w-7xl mx-auto space-y-8">
                <div className="flex items-center justify-between mb-8">
                    <div>
                        <h2 className={`text-4xl font-light text-white tracking-tight ${spaceGrotesk.className}`}>Mission Control</h2>
                        <p className="text-zinc-500 mt-2 text-sm">Manage your drops, track applicants, and review incoming work.</p>
                    </div>
                </div>

                <div className="rounded-2xl border border-zinc-800/60 bg-zinc-900/20 overflow-hidden shadow-2xl">
                    <table className="w-full text-left border-collapse">
                        <thead>
                            <tr className="bg-black/40 border-b border-zinc-800/60 text-[10px] uppercase tracking-widest text-zinc-500 font-bold">
                                <th className="p-5 font-bold">Mission</th>
                                <th className="p-5 font-bold">Status</th>
                                <th className="p-5 font-bold text-center">Applicants</th>
                                <th className="p-5 font-bold text-center">Submissions</th>
                                <th className="p-5 font-bold">Bounty</th>
                                <th className="p-5 font-bold text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-zinc-800/40">
                            {drops.map((drop) => {
                                const isUpdated = new Date(drop.updated_at).getTime() > new Date(drop.created_at).getTime() + 1000;

                                return (
                                    <tr
                                        key={drop.id}
                                        onClick={() => setSelectedDrop(drop)}
                                        className="hover:bg-zinc-800/30 transition-colors group cursor-pointer"
                                    >
                                        <td className="p-5">
                                            <div className="flex items-center gap-3">
                                                <div className="font-medium text-zinc-200 group-hover:text-white transition-colors">
                                                    {drop.title}
                                                </div>
                                                {isUpdated && (
                                                    <span className="px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-wider bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
                                                        Updated
                                                    </span>
                                                )}
                                            </div>
                                            <div className="text-xs text-zinc-600 mt-1">{new Date(drop.created_at).toLocaleDateString()} • {drop.category}</div>
                                        </td>
                                        <td className="p-5">
                                            <StatusBadge status={drop.status} />
                                        </td>
                                        <td className="p-5 text-center">
                                            <div className="inline-flex items-center justify-center min-w-[32px] h-8 px-2 rounded-lg bg-zinc-800/50 text-zinc-300 text-sm font-medium border border-zinc-700/50">
                                                {drop.applicantsCount}
                                            </div>
                                        </td>
                                        <td className="p-5 text-center">
                                            <div className="inline-flex items-center justify-center min-w-[32px] h-8 px-2 rounded-lg bg-emerald-500/10 text-emerald-400 text-sm font-bold border border-emerald-500/20 shadow-inner">
                                                {drop.submissionsCount}
                                            </div>
                                        </td>
                                        <td className="p-5">
                                            <span className="font-mono text-zinc-300 text-sm">${drop.bounty}</span>
                                        </td>
                                        <td className="p-5 text-right relative">
                                            <button
                                                onClick={(e) => {
                                                    e.stopPropagation();
                                                    setActionMenuOpen(actionMenuOpen === drop.id ? null : drop.id);
                                                }}
                                                className="p-2 rounded-lg text-zinc-500 hover:text-white hover:bg-zinc-800 transition-colors"
                                            >
                                                <MoreHorizontal className="w-5 h-5" />
                                            </button>

                                            {actionMenuOpen === drop.id && (
                                                <div className="absolute right-8 top-10 w-48 bg-[#0c0c0e] border border-zinc-800 rounded-xl shadow-2xl z-20 animate-in fade-in zoom-in-95 duration-200 overflow-hidden py-1">
                                                    <button
                                                        onClick={(e) => handleUpdate(drop.id, drop.status === 'open' ? 'cancelled' : 'open', e)}
                                                        className="w-full text-left px-4 py-2.5 text-sm text-zinc-300 hover:bg-zinc-800 hover:text-white transition-colors flex items-center gap-2"
                                                    >
                                                        <Pencil className="w-4 h-4 text-zinc-500" />
                                                        {drop.status === 'open' ? 'Close Mission' : 'Re-open Mission'}
                                                    </button>
                                                    <button
                                                        onClick={(e) => handleDelete(drop.id, e)}
                                                        className="w-full text-left px-4 py-2.5 text-sm text-red-400 hover:bg-red-500/10 transition-colors flex items-center gap-2"
                                                    >
                                                        <Trash2 className="w-4 h-4" /> Delete
                                                    </button>
                                                </div>
                                            )}
                                        </td>
                                    </tr>
                                );
                            })}
                            {drops.length === 0 && (
                                <tr>
                                    <td colSpan={6} className="p-12 text-center text-zinc-500 border-dashed border-zinc-800/50">
                                        No missions created yet.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
