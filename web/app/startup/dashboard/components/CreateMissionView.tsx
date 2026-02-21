"use client";
import { useState, useEffect, useRef } from "react";
import { X, Plus, Paperclip, Briefcase, Zap, ArrowLeft, ArrowRight, CheckCircle2, AlertCircle, Sparkles, Target, Shield, FileText, Code2, DollarSign, Clock, Trash2, Rocket } from "lucide-react";
import { Space_Grotesk } from "next/font/google";
import { supabase } from "@/lib/supabaseClient";

const spaceGrotesk = Space_Grotesk({ subsets: ["latin"], weight: ["300", "400", "500", "600", "700"] });

const CATEGORIES = [
    { id: 'backend', label: 'Backend', icon: <div className="w-2 h-2 rounded-full bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.5)]" /> },
    { id: 'frontend', label: 'Frontend', icon: <div className="w-2 h-2 rounded-full bg-purple-500 shadow-[0_0_8px_rgba(168,85,247,0.5)]" /> },
    { id: 'mobile', label: 'Mobile', icon: <div className="w-2 h-2 rounded-full bg-blue-500 shadow-[0_0_8px_rgba(59,130,246,0.5)]" /> },
    { id: 'design', label: 'Design', icon: <div className="w-2 h-2 rounded-full bg-pink-500 shadow-[0_0_8px_rgba(236,72,153,0.5)]" /> },
    { id: 'devops', label: 'DevOps', icon: <div className="w-2 h-2 rounded-full bg-orange-500 shadow-[0_0_8px_rgba(249,115,22,0.5)]" /> },
    { id: 'ai', label: 'AI/ML', icon: <div className="w-2 h-2 rounded-full bg-indigo-500 shadow-[0_0_8px_rgba(99,102,241,0.5)]" /> }
];

interface CreateMissionProps {
    onClose: () => void;
    onSuccess: () => void;
}

export function CreateMissionView({ onClose, onSuccess }: CreateMissionProps) {
    // Steps: 1. Objective | 2. Intel | 3. Parameters | 4. Bounty | 5. Dispatch
    const [step, setStep] = useState(1);

    // Form State
    const [title, setTitle] = useState("");
    const [category, setCategory] = useState<string>("");

    const [description, setDescription] = useState("");
    const [criteria, setCriteria] = useState<string[]>([]);
    const [criteriaInput, setCriteriaInput] = useState("");
    const [links, setLinks] = useState<string[]>([]);
    const [linkInput, setLinkInput] = useState("");

    const [skills, setSkills] = useState<string[]>([]);
    const [skillInput, setSkillInput] = useState("");
    const [urgency, setUrgency] = useState<'normal' | 'high' | 'urgent'>('normal');

    const [bounty, setBounty] = useState("");
    const [opportunities, setOpportunities] = useState<string[]>([]);

    const [isSubmitting, setIsSubmitting] = useState(false);

    // Hold to Confirm State
    const [holdProgress, setHoldProgress] = useState(0);
    const holdIntervalRef = useRef<NodeJS.Timeout | null>(null);

    // Handlers
    const handleNext = () => setStep(prev => prev + 1);
    const handleBack = () => setStep(prev => prev - 1);

    const addCriteria = () => {
        if (criteriaInput.trim()) {
            setCriteria([...criteria, criteriaInput.trim()]);
            setCriteriaInput("");
        }
    };

    const addLink = () => {
        if (linkInput.trim()) {
            setLinks([...links, linkInput.trim()]);
            setLinkInput("");
        }
    };

    const addSkill = () => {
        if (skillInput.trim() && !skills.includes(skillInput.trim())) {
            setSkills([...skills, skillInput.trim()]);
            setSkillInput("");
        }
    };

    const toggleOpportunity = (opp: string) => {
        if (opportunities.includes(opp)) {
            setOpportunities(opportunities.filter(o => o !== opp));
        } else {
            setOpportunities([...opportunities, opp]);
        }
    };

    // Hold Button Logic
    const startHold = () => {
        if (holdIntervalRef.current) clearInterval(holdIntervalRef.current);
        let progress = 0;
        holdIntervalRef.current = setInterval(() => {
            progress += 4; // Speed of fill
            setHoldProgress(progress);
            if (progress >= 100) {
                if (holdIntervalRef.current) clearInterval(holdIntervalRef.current);
                handleSubmit();
            }
        }, 20);
    };

    const stopHold = () => {
        if (holdIntervalRef.current) {
            clearInterval(holdIntervalRef.current);
            holdIntervalRef.current = null;
        }
        setHoldProgress(0);
    };


    const handleSubmit = async () => {
        setIsSubmitting(true);
        try {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) throw new Error("Not authenticated");

            const { error } = await supabase.from('missions').insert({
                title,
                description,
                category,
                status: 'Open',
                user_id: user.id,
                bounty: parseFloat(bounty),
                urgency,
                requirements: [...criteria, ...skills],
                links,
                created_at: new Date().toISOString()
            });

            if (error) throw error;
            onSuccess();
        } catch (err: any) {
            console.error(err);
            alert("Failed to create mission: " + err.message);
        } finally {
            setIsSubmitting(false);
        }
    };


    // Render Steps
    const renderStep = () => {
        switch (step) {
            case 1: // Identify (Objective)
                return (
                    <div className="space-y-8 animate-in fade-in slide-in-from-right-8 duration-500">
                        <div className="space-y-2 text-center">
                            <span className="text-zinc-500 text-[10px] font-bold tracking-[0.2em] uppercase">Step 01 // Protocol Init</span>
                            <h2 className={`text-5xl text-white font-light ${spaceGrotesk.className} tracking-tight`}>Identify the Mission</h2>
                            <p className="text-zinc-400 font-light">State your primary objective clearly.</p>
                        </div>

                        <div className="space-y-8 max-w-xl mx-auto pt-4">
                            <div className="group">
                                <label className="block text-[10px] font-bold text-zinc-500 mb-3 uppercase tracking-wider group-focus-within:text-emerald-500 transition-colors">Mission Title</label>
                                <input
                                    autoFocus
                                    value={title}
                                    onChange={e => setTitle(e.target.value)}
                                    placeholder="e.g. Optimize Database Queries"
                                    className="w-full bg-zinc-900/50 border border-zinc-800 rounded-2xl p-6 text-2xl text-white placeholder:text-zinc-700 outline-none focus:border-emerald-500/50 focus:bg-zinc-900/80 focus:shadow-[0_0_30px_rgba(16,185,129,0.1)] transition-all font-light"
                                />
                            </div>

                            <div>
                                <label className="block text-[10px] font-bold text-zinc-500 mb-3 uppercase tracking-wider">Functional Area</label>
                                <div className="grid grid-cols-2 gap-3">
                                    {CATEGORIES.map(cat => (
                                        <button
                                            key={cat.id}
                                            onClick={() => setCategory(cat.id)}
                                            className={`group p-4 rounded-xl border text-left flex items-center gap-4 transition-all duration-300 ${category === cat.id
                                                ? 'bg-zinc-100/5 border-zinc-100 text-white shadow-[0_0_20px_rgba(255,255,255,0.05)]'
                                                : 'bg-zinc-900/30 border-zinc-800 text-zinc-500 hover:border-zinc-700 hover:text-zinc-300 hover:bg-zinc-800/50'}`}
                                        >
                                            {cat.icon}
                                            <span className="font-medium text-sm tracking-wide">{cat.label}</span>
                                        </button>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </div>
                );

            case 2: // Intel (Context)
                return (
                    <div className="space-y-8 animate-in fade-in slide-in-from-right-8 duration-500 h-full flex flex-col">
                        <div className="space-y-2 text-center">
                            <span className="text-zinc-500 text-[10px] font-bold tracking-[0.2em] uppercase">Step 02 // gathering intel</span>
                            <h2 className={`text-4xl text-white font-light ${spaceGrotesk.className}`}>Mission Briefing</h2>
                            <p className="text-zinc-400 font-light">Provide the context required to execute.</p>
                        </div>

                        <div className="flex-1 overflow-y-auto w-full max-w-5xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-8 pt-4">

                            {/* LEFT COLUMN: Main Briefing */}
                            <div className="space-y-6">
                                <div className="group h-full flex flex-col">
                                    <label className="flex items-center gap-2 text-[10px] font-bold text-zinc-500 mb-3 uppercase tracking-wider group-focus-within:text-indigo-400 transition-colors">
                                        <FileText className="w-3 h-3" /> Situation Report
                                    </label>
                                    <textarea
                                        value={description}
                                        onChange={e => setDescription(e.target.value)}
                                        placeholder="Describe the current state, the problem, and the desired end-state. Be specific about constraints..."
                                        className="flex-1 w-full bg-zinc-900/50 border border-zinc-800 rounded-2xl p-6 text-sm text-zinc-300 placeholder:text-zinc-700 resize-none outline-none focus:border-indigo-500/50 focus:bg-zinc-900/80 focus:ring-1 focus:ring-indigo-500/10 leading-relaxed transition-all min-h-[300px]"
                                    />
                                </div>
                            </div>

                            {/* RIGHT COLUMN: Supporting Data */}
                            <div className="space-y-8">

                                {/* Definition of Done */}
                                <div className="group bg-zinc-900/20 border border-zinc-800/50 rounded-2xl p-6 hover:border-zinc-700/50 transition-colors">
                                    <label className="flex items-center gap-2 text-[10px] font-bold text-zinc-500 mb-4 uppercase tracking-wider group-focus-within:text-emerald-500 transition-colors">
                                        <Target className="w-3 h-3" /> Definition of Done
                                    </label>

                                    <div className="flex gap-2 mb-4">
                                        <div className="relative flex-1">
                                            <input
                                                value={criteriaInput}
                                                onChange={e => setCriteriaInput(e.target.value)}
                                                onKeyDown={e => e.key === 'Enter' && addCriteria()}
                                                placeholder="Add success criteria..."
                                                className="w-full bg-black/50 border border-zinc-800 rounded-xl px-4 py-3 pl-4 text-sm text-white outline-none focus:border-emerald-500/50 transition-colors"
                                            />
                                        </div>
                                        <button onClick={addCriteria} disabled={!criteriaInput} className="p-3 bg-zinc-800 hover:bg-zinc-700 disabled:opacity-50 rounded-xl text-zinc-400 hover:text-white transition-colors">
                                            <Plus className="w-5 h-5" />
                                        </button>
                                    </div>

                                    <div className="space-y-2 max-h-[160px] overflow-y-auto pr-2">
                                        {criteria.map((c, i) => (
                                            <div key={i} className="flex items-start gap-3 p-3 bg-zinc-900/50 border border-zinc-800/50 rounded-lg group/item hover:border-emerald-500/30 transition-colors">
                                                <div className="w-5 h-5 rounded-full border border-emerald-500/30 flex items-center justify-center mt-0.5 bg-emerald-500/10 group-hover/item:bg-emerald-500/20">
                                                    <CheckCircle2 className="w-3 h-3 text-emerald-500" />
                                                </div>
                                                <span className="text-sm text-zinc-300 flex-1 pt-0.5">{c}</span>
                                                <button onClick={() => setCriteria(criteria.filter((_, idx) => idx !== i))} className="text-zinc-600 hover:text-red-400 opacity-0 group-hover/item:opacity-100 transition-all"><X className="w-4 h-4" /></button>
                                            </div>
                                        ))}
                                        {criteria.length === 0 && (
                                            <div className="text-center py-8 text-zinc-700 text-xs italic border border-dashed border-zinc-800 rounded-lg">
                                                No criteria added yet.
                                            </div>
                                        )}
                                    </div>
                                </div>

                                {/* Assets / Links */}
                                <div className="group bg-zinc-900/20 border border-zinc-800/50 rounded-2xl p-6 hover:border-zinc-700/50 transition-colors">
                                    <label className="flex items-center gap-2 text-[10px] font-bold text-zinc-500 mb-4 uppercase tracking-wider group-focus-within:text-blue-400 transition-colors">
                                        <Shield className="w-3 h-3" /> Secure Assets (Links)
                                    </label>

                                    <div className="flex gap-2 mb-4">
                                        <div className="relative flex-1">
                                            <input
                                                value={linkInput}
                                                onChange={e => setLinkInput(e.target.value)}
                                                onKeyDown={e => e.key === 'Enter' && addLink()}
                                                placeholder="Add URL (Figma, GitHub...)"
                                                className="w-full bg-black/50 border border-zinc-800 rounded-xl px-4 py-3 pl-10 text-sm text-white outline-none focus:border-blue-500/50 transition-colors"
                                            />
                                            <Paperclip className="w-4 h-4 text-zinc-600 absolute left-3 top-3.5" />
                                        </div>
                                        <button onClick={addLink} disabled={!linkInput} className="p-3 bg-zinc-800 hover:bg-zinc-700 disabled:opacity-50 rounded-xl text-zinc-400 hover:text-white transition-colors">
                                            <Plus className="w-5 h-5" />
                                        </button>
                                    </div>

                                    <div className="flex flex-wrap gap-2">
                                        {links.map((l, i) => (
                                            <div key={i} className="group/link flex items-center gap-2 px-3 py-2 bg-blue-500/5 border border-blue-500/20 rounded-lg text-xs text-blue-300 hover:bg-blue-500/10 transition-colors cursor-pointer">
                                                <Paperclip className="w-3 h-3 opacity-50" />
                                                <span className="max-w-[150px] truncate">{l}</span>
                                                <button onClick={() => setLinks(links.filter((_, idx) => idx !== i))} className="hover:text-white ml-1 opacity-50 group-hover/link:opacity-100"><X className="w-3 h-3" /></button>
                                            </div>
                                        ))}
                                        {links.length === 0 && (
                                            <div className="w-full text-center py-4 text-zinc-700 text-xs italic border border-dashed border-zinc-800 rounded-lg">
                                                No assets linked.
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                );

            case 3: // Parameters (Constraints)
                return (
                    <div className="space-y-8 animate-in fade-in slide-in-from-right-8 duration-500">
                        <div className="space-y-2 text-center">
                            <span className="text-zinc-500 text-[10px] font-bold tracking-[0.2em] uppercase">Step 03 // Constraints</span>
                            <h2 className={`text-4xl text-white font-light ${spaceGrotesk.className}`}>Mission Parameters</h2>
                            <p className="text-zinc-400 font-light">Set the operational boundaries.</p>
                        </div>

                        <div className="space-y-10 max-w-xl mx-auto pt-4">
                            <div>
                                <label className="block text-[10px] font-bold text-zinc-500 mb-6 uppercase tracking-wider text-center">Urgency Protocol</label>
                                <div className="grid grid-cols-3 gap-4">
                                    {[
                                        { id: 'normal', label: 'Standard', sub: '3-5 Days', color: 'zinc', icon: Clock },
                                        { id: 'high', label: 'High Priority', sub: '48 Hours', color: 'amber', icon: Zap },
                                        { id: 'urgent', label: 'Critical', sub: 'ASAP', color: 'red', icon: AlertCircle }
                                    ].map((lvl) => (
                                        <button
                                            key={lvl.id}
                                            onClick={() => setUrgency(lvl.id as any)}
                                            className={`relative p-5 rounded-2xl border flex flex-col items-center gap-3 transition-all duration-300 group ${urgency === lvl.id
                                                ? `bg-${lvl.color}-500/10 border-${lvl.color}-500/50 text-${lvl.color}-100 shadow-[0_0_30px_rgba(0,0,0,0.5)]`
                                                : 'bg-zinc-900/40 border-zinc-800 text-zinc-500 hover:border-zinc-700 hover:text-zinc-300 hover:bg-zinc-800/60'}`}
                                        >
                                            {urgency === lvl.id && (
                                                <div className={`absolute inset-0 bg-${lvl.color}-500/5 blur-xl rounded-full`} />
                                            )}
                                            <lvl.icon className={`w-6 h-6 z-10 ${urgency === lvl.id ? `text-${lvl.color}-400` : ''}`} />
                                            <div className="text-center z-10">
                                                <div className="text-sm font-medium tracking-wide">{lvl.label}</div>
                                                <div className={`text-[10px] mt-1 ${urgency === lvl.id ? `text-${lvl.color}-400/80` : 'text-zinc-600'}`}>{lvl.sub}</div>
                                            </div>
                                        </button>
                                    ))}
                                </div>
                            </div>

                            <div className="group">
                                <label className="block text-[10px] font-bold text-zinc-500 mb-3 uppercase tracking-wider group-focus-within:text-white transition-colors">Required Tech Stack to Deploy</label>
                                <div className="flex gap-2 mb-4">
                                    <div className="relative flex-1">
                                        <input
                                            value={skillInput}
                                            onChange={e => setSkillInput(e.target.value)}
                                            onKeyDown={e => e.key === 'Enter' && addSkill()}
                                            placeholder="e.g. React, Python, AWS..."
                                            className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl px-4 py-3 pl-10 text-sm text-white outline-none focus:border-zinc-700 transition-colors"
                                        />
                                        <Code2 className="w-4 h-4 text-zinc-600 absolute left-3 top-3.5" />
                                    </div>
                                    <button onClick={addSkill} className="p-3 bg-zinc-800 hover:bg-zinc-700 rounded-xl text-zinc-400 hover:text-white transition-colors">
                                        <Plus className="w-5 h-5" />
                                    </button>
                                </div>
                                <div className="flex flex-wrap gap-2">
                                    {skills.map((s, i) => (
                                        <div key={i} className="flex items-center gap-1.5 px-3 py-1.5 bg-zinc-800 border border-zinc-700 rounded-lg text-xs text-zinc-300 shadow-sm">
                                            <div className="w-1.5 h-1.5 rounded-full bg-zinc-500" />
                                            <span>{s}</span>
                                            <button onClick={() => setSkills(skills.filter((_, idx) => idx !== i))} className="hover:text-white ml-2"><X className="w-3 h-3" /></button>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </div>
                );

            case 4: // Bounty
                return (
                    <div className="space-y-8 animate-in fade-in slide-in-from-right-8 duration-500">
                        <div className="space-y-2 text-center">
                            <span className="text-zinc-500 text-[10px] font-bold tracking-[0.2em] uppercase">Step 04 // Incentives</span>
                            <h2 className={`text-4xl text-white font-light ${spaceGrotesk.className}`}>Bounty Allocation</h2>
                            <p className="text-zinc-400 font-light">Assign resources to this mission.</p>
                        </div>

                        <div className="space-y-12 max-w-lg mx-auto pt-4">
                            <div className="bg-gradient-to-br from-zinc-900/80 to-black border border-zinc-800 rounded-3xl p-10 text-center relative overflow-hidden group hover:border-emerald-500/30 transition-all duration-500 hover:shadow-[0_0_50px_rgba(16,185,129,0.05)]">
                                <div className="absolute top-0 inset-x-0 h-px bg-gradient-to-r from-transparent via-emerald-500/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                                <div className="absolute inset-0 bg-emerald-500/5 opacity-0 group-hover:opacity-100 transition-opacity duration-500 blur-2xl"></div>

                                <label className="block text-[10px] font-bold text-zinc-500 uppercase tracking-[0.2em] mb-8 relative z-10">Total Bounty (USD)</label>
                                <div className="flex items-center justify-center gap-2 relative z-10">
                                    <span className="text-5xl font-light text-zinc-700 group-focus-within:text-emerald-500/50 transition-colors">$</span>
                                    <input
                                        value={bounty}
                                        onChange={(e) => setBounty(e.target.value)}
                                        placeholder="500"
                                        type="number"
                                        className="bg-transparent text-7xl font-light text-center w-64 outline-none text-white placeholder:text-zinc-800"
                                        autoFocus
                                    />
                                </div>
                                <div className="mt-6 flex flex-wrap justify-center gap-3">
                                    {[
                                        { label: 'Small Fix', amount: '150' },
                                        { label: 'Component', amount: '400' },
                                        { label: 'Module', amount: '1000' }
                                    ].map((preset) => (
                                        <button
                                            key={preset.amount}
                                            onClick={() => setBounty(preset.amount)}
                                            className="px-4 py-2 rounded-full border border-zinc-700 bg-zinc-900/50 text-xs font-medium text-zinc-400 hover:text-white hover:border-emerald-500/50 hover:bg-emerald-500/10 transition-all"
                                        >
                                            <span className="opacity-50 mr-2">{preset.label}</span>
                                            <span className="font-bold text-emerald-400">${preset.amount}</span>
                                        </button>
                                    ))}
                                </div>
                            </div>

                            <div>
                                <label className="block text-[10px] font-bold text-zinc-500 mb-5 uppercase tracking-wider text-center">Bonus Unlocks</label>
                                <div className="grid grid-cols-2 gap-4">
                                    {['Interview Fast-Track', 'Full-Time Role'].map(opp => (
                                        <button
                                            key={opp}
                                            onClick={() => toggleOpportunity(opp)}
                                            className={`p-4 rounded-xl border flex flex-col items-center gap-3 transition-all ${opportunities.includes(opp)
                                                ? 'bg-indigo-500/10 border-indigo-500/50 text-indigo-300 shadow-[0_0_15px_rgba(99,102,241,0.15)]'
                                                : 'bg-zinc-900/30 border-zinc-800 text-zinc-500 hover:border-zinc-700 hover:bg-zinc-800/50'}`}
                                        >
                                            <Briefcase className="w-5 h-5" />
                                            <span className="text-xs font-bold uppercase tracking-wide">{opp}</span>
                                        </button>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </div>
                );

            case 5: // Dispatch (Review)
                return (
                    <div className="space-y-8 animate-in fade-in slide-in-from-right-8 duration-500 max-w-2xl mx-auto w-full">
                        <div className="space-y-2 text-center">
                            <span className="text-emerald-500 text-[10px] font-bold tracking-[0.2em] uppercase flex items-center justify-center gap-2 animate-pulse">
                                <span className="w-1.5 h-1.5 bg-emerald-500 rounded-full"></span> Ready to Launch
                            </span>
                            <h2 className={`text-4xl text-white font-light ${spaceGrotesk.className}`}>Confirm Dispatch</h2>
                        </div>

                        <div className="bg-[#0c0c0e]/50 backdrop-blur-md border border-zinc-800 rounded-3xl overflow-hidden relative shadow-2xl">
                            {/* Dossier Header */}
                            <div className="bg-zinc-900/50 p-8 border-b border-zinc-800 flex justify-between items-start relative">
                                <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-emerald-500 via-teal-500 to-emerald-500 opacity-50"></div>
                                <div>
                                    <div className="flex items-center gap-2 mb-3">
                                        <span className="text-[10px] font-bold uppercase tracking-wider bg-white text-black px-3 py-1 rounded-full">{category}</span>
                                        <span className="text-[10px] font-bold uppercase tracking-wider bg-zinc-800 text-zinc-300 px-3 py-1 rounded-full">{urgency} Priority</span>
                                    </div>
                                    <h3 className="text-3xl font-medium text-white tracking-tight">{title}</h3>
                                </div>
                                <div className="text-right">
                                    <div className="text-4xl font-light text-emerald-400">${bounty}</div>
                                    <div className="text-[10px] text-zinc-500 uppercase tracking-widest mt-1">Bounty Amount</div>
                                </div>
                            </div>

                            {/* Dossier Body */}
                            <div className="p-8 space-y-8">
                                <div>
                                    <h4 className="text-[10px] font-bold text-zinc-500 uppercase tracking-[0.1em] mb-3 flex items-center gap-2">
                                        <FileText className="w-3 h-3" /> Briefing
                                    </h4>
                                    <p className="text-sm text-zinc-300 leading-relaxed font-light">{description}</p>
                                </div>

                                <div className="grid grid-cols-2 gap-10">
                                    <div>
                                        <h4 className="text-[10px] font-bold text-zinc-500 uppercase tracking-[0.1em] mb-3 flex items-center gap-2">
                                            <Target className="w-3 h-3" /> Success Criteria
                                        </h4>
                                        <ul className="space-y-3">
                                            {criteria.map((c, i) => (
                                                <li key={i} className="flex items-start gap-3 text-sm text-zinc-300 font-light">
                                                    <CheckCircle2 className="w-4 h-4 text-emerald-500/50 mt-0.5 shrink-0" /> {c}
                                                </li>
                                            ))}
                                            {criteria.length === 0 && <li className="text-sm text-zinc-600 italic">No specific criteria listed.</li>}
                                        </ul>
                                    </div>
                                    <div>
                                        <h4 className="text-[10px] font-bold text-zinc-500 uppercase tracking-[0.1em] mb-3 flex items-center gap-2">
                                            <Shield className="w-3 h-3" /> Required Capabilities
                                        </h4>
                                        <div className="flex flex-wrap gap-2">
                                            {skills.map((s, i) => (
                                                <span key={i} className="text-xs px-2.5 py-1 bg-zinc-900 border border-zinc-800 rounded-md text-zinc-400">{s}</span>
                                            ))}
                                            {skills.length === 0 && <span className="text-sm text-zinc-600 italic">No specific skills listed.</span>}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* HOLD TO CONFIRM BUTTON */}
                        <div className="pt-8 flex justify-center pb-8">
                            <button
                                onMouseDown={startHold}
                                onMouseUp={stopHold}
                                onMouseLeave={stopHold}
                                onTouchStart={startHold}
                                onTouchEnd={stopHold}
                                disabled={isSubmitting}
                                className="group relative overflow-hidden rounded-full bg-zinc-900 border border-zinc-800 px-10 py-5 transition-all active:scale-95 disabled:opacity-70 cursor-pointer select-none"
                            >
                                {/* Filling Background */}
                                <div
                                    className="absolute inset-y-0 left-0 bg-white transition-all duration-75 ease-linear"
                                    style={{ width: `${holdProgress}%` }}
                                />

                                <span className="relative z-10 flex items-center gap-3 text-lg font-bold text-zinc-300 group-hover:text-white transition-colors mix-blend-exclusion">
                                    {isSubmitting ? (
                                        <div className="flex items-center gap-3">
                                            <div className="w-5 h-5 border-2 border-zinc-500 border-t-white rounded-full animate-spin" />
                                            INITIALIZING...
                                        </div>
                                    ) : (
                                        <>
                                            <Rocket className={`w-5 h-5 ${holdProgress > 0 ? 'animate-bounce' : ''}`} />
                                            {holdProgress > 0 ? "HOLD TO DISPATCH..." : "HOLD TO DISPATCH"}
                                        </>
                                    )}
                                </span>
                            </button>
                        </div>
                    </div>
                );

            default: return null;
        }
    };


    return (
        <div className="fixed inset-0 z-50 bg-[#09090b] text-white flex flex-col animate-in fade-in duration-300">
            {/* Background Texture */}
            <div className="absolute inset-0 z-0 opacity-20 pointer-events-none bg-[url('https://grainy-gradients.vercel.app/noise.svg')] brightness-50 contrast-150"></div>

            {/* Top Bar */}
            <div className="relative z-10 flex items-center justify-between p-8 px-10 border-b border-zinc-800/50 bg-[#09090b]/50 backdrop-blur-xl">
                <div className="flex items-center gap-6">
                    <button onClick={onClose} className="group p-2 hover:bg-zinc-800 rounded-full transition-colors text-zinc-500 hover:text-white">
                        <X className="w-6 h-6 group-hover:rotate-90 transition-transform duration-300" />
                    </button>
                    <div className="h-8 w-px bg-zinc-800"></div>
                    <div>
                        <span className="text-xs font-bold text-zinc-500 uppercase tracking-widest block">New Mission Protocol</span>
                        <span className="text-[10px] text-zinc-700 font-mono">ID: {Math.random().toString(36).substr(2, 9).toUpperCase()}</span>
                    </div>
                </div>

                {/* Progress Indicators */}
                <div className="flex items-center gap-3">
                    {[1, 2, 3, 4, 5].map(s => (
                        <div key={s} className="relative">
                            <div className={`h-1.5 rounded-full transition-all duration-500 ${s <= step ? 'bg-white w-12 shadow-[0_0_10px_rgba(255,255,255,0.3)]' : 'bg-zinc-800 w-4'}`} />
                        </div>
                    ))}
                </div>
            </div>

            {/* Main Content Area */}
            <div className="relative z-10 flex-1 overflow-y-auto flex items-center justify-center p-8 bg-gradient-to-b from-transparent to-zinc-900/20">
                {renderStep()}
            </div>

            {/* Footer Nav */}
            <div className="relative z-10 p-8 border-t border-zinc-800/50 flex justify-between items-center bg-[#09090b] backdrop-blur-xl">
                <button
                    onClick={handleBack}
                    disabled={step === 1}
                    className="flex items-center gap-3 text-zinc-500 hover:text-white disabled:opacity-0 transition-colors px-6 py-3 font-medium tracking-wide uppercase text-xs"
                >
                    <ArrowLeft className="w-4 h-4" /> Go Back
                </button>

                {step < 5 && (
                    <button
                        onClick={handleNext}
                        disabled={
                            (step === 1 && (!title || !category)) ||
                            (step === 2 && !description) ||
                            (step === 3 && false) ||
                            (step === 4 && !bounty)
                        }
                        className="group bg-white text-black px-10 py-4 rounded-full font-bold hover:bg-zinc-200 transition-all flex items-center gap-3 disabled:opacity-50 disabled:cursor-not-allowed shadow-[0_0_20px_rgba(255,255,255,0.1)] hover:shadow-[0_0_30px_rgba(255,255,255,0.2)]"
                    >
                        Next Step <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                    </button>
                )}
            </div>
        </div>
    );
}
