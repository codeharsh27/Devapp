"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Code2, ArrowLeft, Loader2, Save, PlayCircle, Plus, Trash2, Calendar, Users, Award } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

export default function NewDropPage() {
    const router = useRouter();
    const supabase = createClient();
    const [loading, setLoading] = useState(false);

    // Core Fields
    const [title, setTitle] = useState("");
    const [description, setDescription] = useState("");
    const [repoUrl, setRepoUrl] = useState("");
    const [category, setCategory] = useState("backend");
    const [difficulty, setDifficulty] = useState(3);

    // Configurable Fields
    const [deadline, setDeadline] = useState(new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]);
    const [maxSubmissions, setMaxSubmissions] = useState(50);
    const [bounty, setBounty] = useState(0);
    const [isPromoted, setIsPromoted] = useState(false);

    // Dynamic Criteria
    const [criteria, setCriteria] = useState([
        { type: "auto-test", description: "All unit tests pass", weight: 0.6 },
        { type: "manual-review", description: "Code clarity & consistent formatting", weight: 0.2 },
        { type: "performance", description: "Execution time < 100ms", weight: 0.2 }
    ]);

    const totalWeight = criteria.reduce((acc, curr) => acc + curr.weight, 0);
    const weightIsValid = Math.abs(totalWeight - 1.0) < 0.01;

    const addCriteria = () => {
        setCriteria([...criteria, { type: "manual-review", description: "New Criterion", weight: 0.1 }]);
    };

    const removeCriteria = (index: number) => {
        const newCriteria = [...criteria];
        newCriteria.splice(index, 1);
        setCriteria(newCriteria);
    };

    const updateCriteria = (index: number, field: string, value: any) => {
        const newCriteria = [...criteria];
        // @ts-ignore
        newCriteria[index][field] = value;
        setCriteria(newCriteria);
    };

    const handleCreate = async () => {
        if (!title || !description || !repoUrl) return;
        if (!weightIsValid) {
            alert("Criteria weights must sum to 100%");
            return;
        }

        setLoading(true);
        try {
            const res = await fetch('/api/tasks', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    title,
                    description,
                    repo_template_url: repoUrl,
                    category,
                    difficulty_level: difficulty,
                    deadline: new Date(deadline).toISOString(),
                    max_submissions: maxSubmissions,
                    bounty_amount: bounty,
                    is_promoted: isPromoted,
                    criteria
                })
            });

            const data = await res.json();
            if (!res.ok) throw new Error(data.error || "Failed to create task");

            router.push(`/startup/dashboard`);
        } catch (err: any) {
            alert(err.message);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="min-h-screen bg-black text-white p-8 font-mono">
            <div className="max-w-4xl mx-auto space-y-8 pb-24">
                {/* Header */}
                <div className="flex items-center gap-4 border-b border-white/10 pb-6">
                    <button onClick={() => router.back()} className="p-2 hover:bg-white/10 rounded-full transition-colors">
                        <ArrowLeft className="w-5 h-5" />
                    </button>
                    <div>
                        <h1 className="text-2xl font-bold">Create New Mission</h1>
                        <p className="text-xs text-gray-500 uppercase tracking-widest">START A NEW PROJECT</p>
                    </div>
                </div>

                {/* Form */}
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">

                    {/* Main Settings */}
                    <div className="lg:col-span-2 space-y-6">
                        <div className="bg-[#111] border border-white/10 rounded-xl p-8 space-y-6">
                            <div className="space-y-2">
                                <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Project Title</label>
                                <input
                                    value={title}
                                    onChange={(e) => setTitle(e.target.value)}
                                    className="w-full bg-[#0A0A0A] border border-white/10 rounded p-4 text-white focus:outline-none focus:border-white/50 transition-colors"
                                    placeholder="e.g. Fix Memory Leak in Payment Service"
                                />
                            </div>

                            <div className="space-y-2">
                                <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Payment Amount (USD)</label>
                                <div className="flex items-center gap-2 bg-[#0A0A0A] border border-white/10 rounded p-4">
                                    <span className="text-green-500 font-bold">$</span>
                                    <input
                                        type="number"
                                        min="0"
                                        value={bounty}
                                        onChange={(e) => setBounty(parseFloat(e.target.value))}
                                        className="flex-1 bg-transparent border-none focus:outline-none text-white font-mono text-lg"
                                        placeholder="0.00"
                                    />
                                </div>
                            </div>

                            <div className="grid md:grid-cols-2 gap-6">
                                <div className="space-y-2">
                                    <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Project Type</label>
                                    <select
                                        value={category}
                                        onChange={(e) => setCategory(e.target.value)}
                                        className="w-full bg-[#0A0A0A] border border-white/10 rounded p-4 text-white focus:outline-none focus:border-white/50 transition-colors appearance-none cursor-pointer"
                                    >
                                        <option value="backend">Backend Systems</option>
                                        <option value="frontend">Frontend UI</option>
                                        <option value="smart-contract">Smart Contracts</option>
                                        <option value="mobile">Mobile App</option>
                                    </select>
                                </div>
                                <div className="space-y-2">
                                    <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Estimated Difficulty</label>
                                    <input
                                        type="range"
                                        min="1"
                                        max="5"
                                        value={difficulty}
                                        onChange={(e) => setDifficulty(parseInt(e.target.value))}
                                        className="w-full h-2 bg-gray-700 rounded-lg appearance-none cursor-pointer mt-4"
                                    />
                                    <div className="flex justify-between text-xs text-gray-500 font-mono">
                                        <span>Beginner</span>
                                        <span>Junior</span>
                                        <span className={difficulty >= 3 ? "text-white" : ""}>Mid</span>
                                        <span className={difficulty >= 4 ? "text-white" : ""}>Senior</span>
                                        <span className={difficulty === 5 ? "text-red-500 font-bold" : ""}>Expert</span>
                                    </div>
                                </div>
                            </div>

                            <div className="space-y-2">
                                <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Starter Code Link (GitHub)</label>
                                <div className="flex items-center gap-2 bg-[#0A0A0A] border border-white/10 rounded p-4">
                                    <Code2 className="w-5 h-5 text-gray-500" />
                                    <input
                                        value={repoUrl}
                                        onChange={(e) => setRepoUrl(e.target.value)}
                                        className="flex-1 bg-transparent border-none focus:outline-none text-white font-mono text-sm"
                                        placeholder="https://github.com/startup/task-template"
                                    />
                                </div>
                                <p className="text-[10px] text-gray-500">* Developers will use this code as a base for their work.</p>
                            </div>

                            <div className="space-y-2">
                                <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Project Details</label>
                                <textarea
                                    value={description}
                                    onChange={(e) => setDescription(e.target.value)}
                                    className="w-full h-40 bg-[#0A0A0A] border border-white/10 rounded p-4 text-white focus:outline-none focus:border-white/50 transition-colors font-mono text-sm resize-none"
                                    placeholder="Describe the task in plain English. What needs to be fixed or built?"
                                />
                            </div>
                        </div>
                    </div>

                    {/* Right Config Panel */}
                    <div className="space-y-6">

                        {/* Constraints */}
                        <div className="bg-[#111] border border-white/10 rounded-xl p-6 space-y-4">
                            <h3 className="text-sm font-bold flex items-center gap-2">
                                <Calendar className="w-4 h-4 text-indigo-400" /> Project Settings
                            </h3>

                            <div className="space-y-2">
                                <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Deadline</label>
                                <input
                                    type="date"
                                    value={deadline}
                                    onChange={(e) => setDeadline(e.target.value)}
                                    className="w-full bg-[#0A0A0A] border border-white/10 rounded p-3 text-white focus:outline-none text-sm font-mono"
                                />
                            </div>

                            <div className="space-y-2">
                                <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Max Applications</label>
                                <div className="flex items-center gap-2 bg-[#0A0A0A] border border-white/10 rounded p-3">
                                    <Users className="w-4 h-4 text-gray-500" />
                                    <input
                                        type="number"
                                        min="1"
                                        max="500"
                                        value={maxSubmissions}
                                        onChange={(e) => setMaxSubmissions(parseInt(e.target.value))}
                                        className="flex-1 bg-transparent border-none focus:outline-none text-white font-mono text-sm"
                                    />
                                </div>
                            </div>

                            {/* Promotion Config */}
                            <div className="pt-4 border-t border-white/10">
                                <label className="flex items-center justify-between cursor-pointer group">
                                    <div>
                                        <div className="text-xs font-bold text-amber-500 uppercase tracking-widest flex items-center gap-2">
                                            <Award className="w-4 h-4" /> Promoted Drop
                                        </div>
                                        <div className="text-xs text-gray-500 mt-1">Boost visibility by 3x ($49)</div>
                                    </div>
                                    <div className={`w-12 h-6 rounded-full p-1 transition-colors ${isPromoted ? 'bg-amber-500' : 'bg-zinc-800'}`}>
                                        <div className={`w-4 h-4 rounded-full bg-white shadow-sm transition-transform ${isPromoted ? 'translate-x-6' : 'translate-x-0'}`} />
                                    </div>
                                    <input
                                        type="checkbox"
                                        className="hidden"
                                        checked={isPromoted}
                                        onChange={(e) => setIsPromoted(e.target.checked)}
                                    />
                                </label>
                            </div>
                        </div>

                        {/* Criteria */}
                        <div className="bg-[#111] border border-white/10 rounded-xl p-6">
                            <h3 className="text-sm font-bold mb-4 flex items-center gap-2 justify-between">
                                <div className="flex items-center gap-2">
                                    <PlayCircle className="w-4 h-4 text-green-500" /> Evaluation Criteria
                                </div>
                                <span className={`text-xs font-mono px-2 py-0.5 rounded ${weightIsValid ? 'bg-green-500/20 text-green-400' : 'bg-red-500/20 text-red-400'}`}>
                                    {(totalWeight * 100).toFixed(0)}%
                                </span>
                            </h3>

                            <div className="space-y-3 mb-4">
                                {criteria.map((c, i) => (
                                    <div key={i} className="flex gap-2 text-xs bg-[#0A0A0A] p-2 rounded border border-white/5 items-start">
                                        <div className="flex-1 space-y-1">
                                            <input
                                                value={c.description}
                                                onChange={(e) => updateCriteria(i, 'description', e.target.value)}
                                                className="w-full bg-transparent border-none focus:outline-none text-gray-300 placeholder:text-gray-700"
                                                placeholder="Criterion Description"
                                            />
                                            <select
                                                value={c.type}
                                                onChange={(e) => updateCriteria(i, 'type', e.target.value)}
                                                className="bg-transparent text-[10px] text-gray-500 uppercase tracking-wider focus:outline-none"
                                            >
                                                <option value="auto-test">Automated Check</option>
                                                <option value="manual-review">Manual Review</option>
                                                <option value="performance">Speed Test</option>
                                            </select>
                                        </div>
                                        <div className="flex flex-col items-end gap-1">
                                            <div className="flex items-center gap-1">
                                                <input
                                                    type="number"
                                                    step="0.1"
                                                    min="0.1"
                                                    max="1.0"
                                                    value={c.weight}
                                                    onChange={(e) => updateCriteria(i, 'weight', parseFloat(e.target.value))}
                                                    className="w-12 bg-zinc-900 text-right border border-zinc-700 rounded px-1 py-0.5 text-white focus:outline-none font-mono"
                                                />
                                            </div>
                                            <button onClick={() => removeCriteria(i)} className="text-zinc-600 hover:text-red-400">
                                                <Trash2 className="w-3 h-3" />
                                            </button>
                                        </div>
                                    </div>
                                ))}
                            </div>

                            <button
                                onClick={addCriteria}
                                className="w-full py-2 border border-dashed border-zinc-700 rounded hover:bg-zinc-900/50 text-xs text-zinc-500 hover:text-white transition-colors flex items-center justify-center gap-2"
                            >
                                <Plus className="w-3 h-3" /> Add Rule
                            </button>
                        </div>
                    </div>

                </div>

                {/* Actions */}
                <div className="fixed bottom-0 inset-x-0 p-4 bg-black/80 backdrop-blur border-t border-white/10 flex justify-end gap-4 z-10 pr-12">
                    <button
                        onClick={() => router.back()}
                        className="px-6 py-3 text-xs font-bold uppercase tracking-widest text-gray-500 hover:text-white transition-colors"
                    >
                        Cancel
                    </button>
                    <button
                        onClick={handleCreate}
                        disabled={loading || !title || !repoUrl || !weightIsValid}
                        className="bg-white text-black px-8 py-3 rounded-lg font-bold uppercase tracking-widest hover:bg-gray-200 transition-colors disabled:opacity-50 flex items-center gap-2 mb-2"
                    >
                        {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
                        Post Mission
                    </button>
                </div>
            </div>
        </div>
    );
}
