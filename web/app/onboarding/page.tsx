"use client";

import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import { ArrowRight, ArrowLeft, CheckCircle2, User, Code2, Briefcase, Zap, Loader2, Plus, X } from "lucide-react";

type ProfileData = {
    full_name: string;
    username: string;
    bio: string;
    role: string;
    years_experience: number;
    tech_stack: string[];
    github_url: string;
    linkedin_url: string;
    portfolio_url: string;
    location: string;
    collaboration_open: boolean;
    freelance_open: boolean;
};

const STEPS = [
    { id: 1, title: "Identity", icon: User },
    { id: 2, title: "Capabilities", icon: Code2 },
    { id: 3, title: "Preferences", icon: Zap },
];

const ROLES = ["Frontend Engineer", "Backend Engineer", "Full Stack Developer", "Mobile Developer", "DevOps / SRE", "AI / ML Engineer", "Blockchain Developer"];
const TECH_STACK_OPTIONS = ["React", "Next.js", "Vue", "Angular", "Node.js", "Python", "Go", "Rust", "Java", "Docker", "Kubernetes", "AWS", "Supabase", "PostgreSQL", "Solidity"];

export default function OnboardingPage() {
    const supabase = createClient();
    const router = useRouter();
    const [step, setStep] = useState(1);
    const [isLoading, setIsLoading] = useState(false);
    const [userId, setUserId] = useState<string | null>(null);
    const [techInput, setTechInput] = useState("");

    const [formData, setFormData] = useState<ProfileData>({
        full_name: "",
        username: "",
        bio: "",
        role: "",
        years_experience: 0,
        tech_stack: [],
        github_url: "",
        linkedin_url: "",
        portfolio_url: "",
        location: "",
        collaboration_open: true,
        freelance_open: false,
    });

    useEffect(() => {
        const checkUser = async () => {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) {
                router.push("/auth");
                return;
            }
            setUserId(user.id);
            // Pre-fill from metadata if available
            setFormData(prev => ({
                ...prev,
                full_name: user.user_metadata.full_name || prev.full_name,
                username: user.user_metadata.username || prev.username,
            }));
        };
        checkUser();
    }, [router, supabase]);

    const handleNext = () => {
        setStep(prev => Math.min(prev + 1, 3));
    };

    const handleBack = () => {
        setStep(prev => Math.max(prev - 1, 1));
    };

    const handleSubmit = async () => {
        if (!userId) return;
        setIsLoading(true);
        try {
            // 1. Update Profile in Database
            const { error: profileError } = await supabase
                .from("profiles")
                .upsert({
                    id: userId,
                    ...formData,
                    updated_at: new Date().toISOString(),
                });

            if (profileError) throw profileError;

            // 2. Update User Metadata for Middleware Routing
            const { error: userError } = await supabase.auth.updateUser({
                data: {
                    user_type: 'talent', // Explicitly mark as talent/developer
                    full_name: formData.full_name,
                    username: formData.username
                }
            });

            if (userError) throw userError;

            // 3. Force refresh to update cookies/session before redirecting
            router.refresh();

            // Short delay to ensure propagation
            setTimeout(() => {
                window.location.href = "/talent/dashboard"; // Force full reload/navigate to avoid Next.js cache issues
            }, 500);

        } catch (error) {
            console.error("Error updating profile:", error);
            alert("Failed to save profile. Please try again.");
            setIsLoading(false);
        }
    };

    const updateField = (field: keyof ProfileData, value: any) => {
        setFormData(prev => ({ ...prev, [field]: value }));
    };

    const toggleTechStack = (tech: string) => {
        setFormData(prev => {
            const stack = prev.tech_stack.includes(tech)
                ? prev.tech_stack.filter(t => t !== tech)
                : [...prev.tech_stack, tech];
            return { ...prev, tech_stack: stack };
        });
        setTechInput(""); // Clear input after selection
    };

    const filteredTechOptions = TECH_STACK_OPTIONS.filter(
        t => t.toLowerCase().includes(techInput.toLowerCase()) && !formData.tech_stack.includes(t)
    );

    return (
        <div className="min-h-screen bg-black text-white flex flex-col md:flex-row font-sans selection:bg-gray-800 selection:text-white">
            {/* Sidebar / Progress */}
            <div className="w-full md:w-1/3 lg:w-1/4 bg-[#0A0A0A] border-r border-white/10 p-8 flex flex-col justify-between">
                <div>
                    <div className="flex items-center justify-between mb-12">
                        <div className="flex items-center gap-2">
                            <div className="w-8 h-8 bg-white flex items-center justify-center">
                                <Code2 className="w-4 h-4 text-black" />
                            </div>
                            <span className="font-bold text-lg tracking-tight uppercase">Setup_Node</span>
                        </div>
                        <button
                            onClick={async () => {
                                await supabase.auth.signOut();
                                router.refresh();
                                router.push("/");
                            }}
                            className="md:hidden text-xs text-gray-500 hover:text-white uppercase tracking-widest"
                        >
                            Abort
                        </button>
                    </div>

                    <div className="space-y-8">
                        {STEPS.map((s) => {
                            const Icon = s.icon;
                            const isActive = s.id === step;
                            const isCompleted = s.id < step;

                            return (
                                <div key={s.id} className={`flex items-center gap-4 transition-colors ${isActive ? 'text-white' : 'text-gray-600'}`}>
                                    <div className={`w-8 h-8 rounded-full flex items-center justify-center border ${isActive ? 'border-white bg-white text-black' : isCompleted ? 'border-green-500 bg-green-500/10 text-green-500' : 'border-gray-800 bg-black text-gray-800'}`}>
                                        {isCompleted ? <CheckCircle2 className="w-4 h-4" /> : <span className="text-xs font-mono font-bold">{s.id}</span>}
                                    </div>
                                    <div>
                                        <div className="text-xs font-bold uppercase tracking-widest">{s.title}</div>
                                        {isActive && <div className="text-[10px] text-gray-500 font-mono mt-1">In Progress...</div>}
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                </div>

                <div className="text-xs text-gray-600 font-mono hidden md:block">
                    SESSION_ID: {userId?.substring(0, 8) || "INIT..."}<br />
                    V 2.0.4
                    <button
                        onClick={async () => {
                            await supabase.auth.signOut();
                            router.refresh();
                            router.push("/");
                        }}
                        className="block mt-4 text-xs text-red-500 hover:text-red-400 uppercase tracking-widest"
                    >
                        &gt; Term_Session
                    </button>
                </div>
            </div>

            {/* Main Form Area */}
            <div className="flex-1 p-8 md:p-16 overflow-y-auto">
                <div className="max-w-2xl mx-auto">
                    <AnimatePresence mode="wait">
                        <motion.div
                            key={step}
                            initial={{ opacity: 0, x: 20 }}
                            animate={{ opacity: 1, x: 0 }}
                            exit={{ opacity: 0, x: -20 }}
                            transition={{ duration: 0.3 }}
                        >
                            {step === 1 && (
                                <div className="space-y-6">
                                    <h2 className="text-3xl font-bold tracking-tighter mb-8">Node Identification.</h2>

                                    <div className="grid md:grid-cols-2 gap-6">
                                        <div className="space-y-2">
                                            <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Full Name</label>
                                            <input
                                                type="text"
                                                value={formData.full_name}
                                                onChange={(e) => updateField("full_name", e.target.value)}
                                                className="w-full bg-[#111] border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                                placeholder="e.g. Alex Chen"
                                            />
                                        </div>
                                        <div className="space-y-2">
                                            <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Username</label>
                                            <input
                                                type="text"
                                                value={formData.username}
                                                onChange={(e) => updateField("username", e.target.value)}
                                                className="w-full bg-[#111] border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                                placeholder="e.g. alex_c"
                                            />
                                        </div>
                                    </div>

                                    <div className="space-y-2">
                                        <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Short Bio</label>
                                        <textarea
                                            value={formData.bio}
                                            onChange={(e) => updateField("bio", e.target.value)}
                                            rows={4}
                                            className="w-full bg-[#111] border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm resize-none"
                                            placeholder="Tell us about your engineering philosophy..."
                                        />
                                    </div>

                                    <div className="space-y-2">
                                        <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Location</label>
                                        <input
                                            type="text"
                                            value={formData.location}
                                            onChange={(e) => updateField("location", e.target.value)}
                                            className="w-full bg-[#111] border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                            placeholder="e.g. San Francisco, CA (or Remote)"
                                        />
                                    </div>
                                </div>
                            )}

                            {step === 2 && (
                                <div className="space-y-6">
                                    <h2 className="text-3xl font-bold tracking-tighter mb-8">System Capabilities.</h2>

                                    <div className="space-y-2">
                                        <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Primary Role</label>
                                        <select
                                            value={formData.role}
                                            onChange={(e) => updateField("role", e.target.value)}
                                            className="w-full bg-[#111] border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm appearance-none"
                                        >
                                            <option value="">Select Role</option>
                                            {ROLES.map(role => (
                                                <option key={role} value={role}>{role}</option>
                                            ))}
                                        </select>
                                    </div>

                                    <div className="space-y-2">
                                        <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Years of Experience</label>
                                        <input
                                            type="number"
                                            value={formData.years_experience}
                                            onChange={(e) => updateField("years_experience", parseInt(e.target.value))}
                                            className="w-full bg-[#111] border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                            min={0}
                                            max={50}
                                        />
                                    </div>

                                    <div className="space-y-4">
                                        <div className="flex justify-between items-end">
                                            <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Tech Stack</label>
                                            <span className="text-[10px] text-green-500 font-mono tracking-tight animate-pulse">
                                                &gt; DEFINE_YOUR_ARSENAL. WHAT TOOLS DO YOU WIELD?
                                            </span>
                                        </div>

                                        <div className="space-y-3">
                                            {/* Selected Tags */}
                                            <div className="flex flex-wrap gap-2 min-h-[32px]">
                                                {formData.tech_stack.map(tech => (
                                                    <button
                                                        key={tech}
                                                        onClick={() => toggleTechStack(tech)}
                                                        className="px-3 py-1.5 text-xs font-mono bg-white text-black border border-white flex items-center gap-2 group hover:bg-gray-200 transition-colors"
                                                    >
                                                        {tech}
                                                        <X className="w-3 h-3 text-gray-500 group-hover:text-black" />
                                                    </button>
                                                ))}
                                            </div>

                                            {/* Input Area */}
                                            <div className="relative">
                                                <input
                                                    type="text"
                                                    value={techInput}
                                                    onChange={(e) => setTechInput(e.target.value)}
                                                    onKeyDown={(e) => {
                                                        if (e.key === 'Enter') {
                                                            e.preventDefault();
                                                            if (techInput.trim() && !formData.tech_stack.includes(techInput.trim())) {
                                                                toggleTechStack(techInput.trim());
                                                            }
                                                        }
                                                    }}
                                                    className="w-full bg-[#111] border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                                    placeholder="Type to search or add custom stack..."
                                                />
                                                <div className="absolute right-3 top-1/2 -translate-y-1/2">
                                                    <Plus className="w-4 h-4 text-gray-500" />
                                                </div>
                                            </div>

                                            {/* Suggestions */}
                                            {techInput && (
                                                <div className="bg-[#111] border border-white/10 rounded-b mt-1 max-h-48 overflow-y-auto">
                                                    {filteredTechOptions.length > 0 ? (
                                                        filteredTechOptions.map(tech => (
                                                            <button
                                                                key={tech}
                                                                onClick={() => toggleTechStack(tech)}
                                                                className="w-full text-left px-4 py-2 text-xs font-mono text-gray-400 hover:bg-white/5 hover:text-white transition-colors"
                                                            >
                                                                {tech}
                                                            </button>
                                                        ))
                                                    ) : (
                                                        <button
                                                            onClick={() => toggleTechStack(techInput)}
                                                            className="w-full text-left px-4 py-2 text-xs font-mono text-green-500 hover:bg-white/5 transition-colors"
                                                        >
                                                            Add &quot;{techInput}&quot; to arsenal
                                                        </button>
                                                    )}
                                                </div>
                                            )}
                                        </div>
                                    </div>

                                    <div className="space-y-2 pt-4">
                                        <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">GitHub URL</label>
                                        <input
                                            type="url"
                                            value={formData.github_url}
                                            onChange={(e) => updateField("github_url", e.target.value)}
                                            className="w-full bg-[#111] border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                            placeholder="https://github.com/..."
                                        />
                                    </div>

                                    <div className="space-y-2">
                                        <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">LinkedIn URL</label>
                                        <input
                                            type="url"
                                            value={formData.linkedin_url}
                                            onChange={(e) => updateField("linkedin_url", e.target.value)}
                                            className="w-full bg-[#111] border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                            placeholder="https://linkedin.com/in/..."
                                        />
                                    </div>
                                </div>
                            )}

                            {step === 3 && (
                                <div className="space-y-6">
                                    <h2 className="text-3xl font-bold tracking-tighter mb-8">Node Configuration.</h2>

                                    <div className="space-y-4">
                                        <div className="flex items-center justify-between p-6 bg-[#111] border border-white/10">
                                            <div>
                                                <h3 className="font-bold text-white mb-1">Global Leaderboard</h3>
                                                <p className="text-xs text-gray-500">Display your reputation score and rank publicly.</p>
                                            </div>
                                            <button
                                                onClick={() => updateField("collaboration_open", !formData.collaboration_open)}
                                                className={`w-12 h-6 rounded-full relative transition-colors ${formData.collaboration_open ? "bg-green-500" : "bg-gray-800"}`}
                                            >
                                                <div className={`absolute top-1 w-4 h-4 bg-white rounded-full transition-all ${formData.collaboration_open ? "left-7" : "left-1"}`} />
                                            </button>
                                        </div>

                                        <div className="flex items-center justify-between p-6 bg-[#111] border border-white/10">
                                            <div>
                                                <h3 className="font-bold text-white mb-1">Open to Opportunities</h3>
                                                <p className="text-xs text-gray-500">Signal to startups that you are available for full-time roles.</p>
                                            </div>
                                            <button
                                                onClick={() => updateField("freelance_open", !formData.freelance_open)}
                                                className={`w-12 h-6 rounded-full relative transition-colors ${formData.freelance_open ? "bg-green-500" : "bg-gray-800"}`}
                                            >
                                                <div className={`absolute top-1 w-4 h-4 bg-white rounded-full transition-all ${formData.freelance_open ? "left-7" : "left-1"}`} />
                                            </button>
                                        </div>
                                    </div>

                                    <div className="space-y-2 pt-4">
                                        <label className="text-xs font-bold text-gray-500 uppercase tracking-widest">Portfolio / Website</label>
                                        <input
                                            type="url"
                                            value={formData.portfolio_url}
                                            onChange={(e) => updateField("portfolio_url", e.target.value)}
                                            className="w-full bg-[#111] border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                            placeholder="https://..."
                                        />
                                    </div>
                                </div>
                            )}
                        </motion.div>
                    </AnimatePresence>

                    {/* Navigation */}
                    <div className="flex justify-between mt-12 pt-8 border-t border-white/10">
                        {step > 1 ? (
                            <button
                                onClick={handleBack}
                                className="flex items-center gap-2 text-xs font-bold uppercase tracking-widest text-gray-500 hover:text-white transition-colors"
                            >
                                <ArrowLeft className="w-4 h-4" /> Back
                            </button>
                        ) : (
                            <div></div>
                        )}

                        <button
                            onClick={step === 3 ? handleSubmit : handleNext}
                            disabled={isLoading}
                            className="bg-white text-black font-bold uppercase tracking-widest px-8 py-3 hover:bg-gray-200 transition-colors text-xs flex items-center gap-2 disabled:opacity-50"
                        >
                            {isLoading ? (
                                <Loader2 className="w-4 h-4 animate-spin" />
                            ) : (
                                <>
                                    {step === 3 ? "Initialize Node" : "Next Step"} <ArrowRight className="w-4 h-4" />
                                </>
                            )}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}
