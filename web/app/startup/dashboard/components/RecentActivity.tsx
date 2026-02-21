"use client";
import { ArrowUp, ChevronDown, Plus } from "lucide-react";

function ProjectCard({ title, company, status, candidates }: { title: string, company: string, status: string, candidates: number }) {
    return (
        <div className="group relative rounded-xl border border-zinc-800 bg-zinc-900/20 hover:bg-zinc-900/40 hover:border-zinc-700 transition-all cursor-pointer overflow-hidden backdrop-blur-sm">
            <div className="p-5 space-y-4">
                <div className="flex justify-between items-start">
                    <div className="space-y-1 max-w-[70%]">
                        <h4 className="font-medium text-zinc-200 group-hover:text-white truncate leading-tight">{title}</h4>
                        <p className="text-xs text-zinc-500 flex items-center gap-1.5">
                            <span className="w-1.5 h-1.5 rounded-full bg-indigo-500/50"></span>
                            {company}
                        </p>
                    </div>
                    <span className={`px-2 py-1 rounded-md text-[10px] font-medium border ${status === 'Shipped' ? 'bg-emerald-900/10 text-emerald-400 border-emerald-900/20' : 'bg-amber-900/10 text-amber-400 border-amber-900/20'}`}>
                        {status}
                    </span>
                </div>

                <div className="pt-4 border-t border-white/5 flex items-center justify-between text-xs text-zinc-500">
                    <div className="flex -space-x-2">
                        {[1, 2, 3].map(i => (
                            <div key={i} className="w-6 h-6 rounded-full bg-zinc-800 border-2 border-[#0c0c0e] flex items-center justify-center text-[8px] text-zinc-400">
                                {i}
                            </div>
                        ))}
                    </div>
                    <div className="flex items-center gap-1.5 group-hover:text-zinc-300 transition-colors">
                        <span>View Details</span>
                        <ArrowUp className="w-3 h-3 rotate-45" />
                    </div>
                </div>
            </div>
        </div>
    );
}

export function RecentActivity({ step, currentView }: { step: number, currentView: string }) {
    if (currentView !== 'wizard') return null;

    return (
        <div className={`bg-[#09090b] border-t border-zinc-800/50 flex-1 px-8 py-12 relative z-10 transition-opacity duration-500 ${step > 1 ? 'opacity-30 pointer-events-none filter blur-sm' : 'opacity-100'}`}>
            <div className="flex items-center justify-between mb-8 max-w-6xl mx-auto">
                <div className="space-y-1">
                    <h3 className="text-lg font-medium text-zinc-200 tracking-tight flex items-center gap-2">
                        Recent Activity
                    </h3>
                </div>

                <button className="text-sm text-zinc-500 hover:text-zinc-300 flex items-center gap-1 transition-colors">
                    View All <ChevronDown className="w-4 h-4 -rotate-90" />
                </button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 max-w-6xl mx-auto mb-20">
                <ProjectCard
                    title="MVP Landing Page"
                    company="Radius"
                    status="Shipped"
                    candidates={5}
                />
                <ProjectCard
                    title="Mobile App Auth"
                    company="Flow"
                    status="Reviewing"
                    candidates={8}
                />
                <ProjectCard
                    title="Dashboard Analytics"
                    company="Echo"
                    status="Reviewing"
                    candidates={12}
                />
                <div className="group relative rounded-xl border border-zinc-800 bg-zinc-900/10 p-6 flex flex-col items-center justify-center gap-3 hover:bg-zinc-900/20 hover:border-zinc-700 transition-all cursor-pointer border-dashed min-h-[140px]">
                    <div className="w-10 h-10 rounded-full bg-zinc-900 border border-zinc-800 group-hover:bg-zinc-800 flex items-center justify-center text-zinc-500 group-hover:text-zinc-300 transition-colors">
                        <Plus className="w-5 h-5" />
                    </div>
                    <span className="text-sm font-medium text-zinc-500 group-hover:text-zinc-400">Delegate New Task</span>
                </div>
            </div>
        </div>
    );
}
