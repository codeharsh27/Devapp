"use client";

import { motion } from "framer-motion";
import { Check, ArrowRight, Loader2, Code2 } from "lucide-react";
import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function StartupOnboarding() {
    const supabase = createClient();
    const [step, setStep] = useState(1);
    const [isLoading, setIsLoading] = useState(false);
    const [sessionError, setSessionError] = useState(false);
    const router = useRouter();

    const [companyName, setCompanyName] = useState("");
    const [website, setWebsite] = useState("");
    const [role, setRole] = useState("");
    const [teamSize, setTeamSize] = useState("");
    const [description, setDescription] = useState("");

    // Verify Session on Load
    useEffect(() => {
        const checkUser = async () => {
            const { data: { user } } = await supabase.auth.getUser();

            if (!user) {
                // If user accidentally logs out or session is lost
                setSessionError(true);
                return;
            }

            // Check if user already has a profile & role
            const { data: profile } = await supabase
                .from('profiles')
                .select('role')
                .eq('id', user.id)
                .single();

            // If profile exists with a role, they don't need onboarding
            if (profile?.role) {
                const startupRoles = ['Founder', 'Co-Founder', 'CTO', 'VP of Engineering', 'Head of Product', 'Product Manager', 'Engineering Lead'];
                if (startupRoles.includes(profile.role)) {
                    router.push("/dashboard");
                } else {
                    router.push("/dashboard");
                }
            }
        };
        checkUser();
    }, [router]);

    const handleSubmit = async () => {
        if (!companyName || !role) return;
        setIsLoading(true);

        try {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) throw new Error("No user found");

            // 1. Update Profile (Store role, bio, and portfolio link)
            const { error: profileError } = await supabase
                .from('profiles')
                .upsert({
                    id: user.id,
                    full_name: user.user_metadata?.full_name || "",
                    role: role,
                    bio: description,
                    portfolio_url: website, // Storing website here as per schema usage
                    updated_at: new Date().toISOString(),
                });

            if (profileError) throw profileError;

            // 2. Update User Metadata (Store company info & team size)
            // CRITICAL: Explicitly set user_type to 'startup' to ensure correct routing
            const { error: userError } = await supabase.auth.updateUser({
                data: {
                    user_type: 'startup',
                    company_name: companyName,
                    website: website,
                    team_size: teamSize,
                    onboarding_completed: true
                }
            });

            if (userError) throw userError;

            // Refresh router to update session/protection state then redirect
            router.refresh();
            setTimeout(() => {
                window.location.href = "/startup/dashboard";
            }, 500);

        } catch (error) {
            console.error("Onboarding Error:", error);
            setIsLoading(false);
            alert("An error occurred during setup. Please try again.");
        }
    };

    if (sessionError) {
        return (
            <div className="min-h-screen bg-black text-white flex flex-col items-center justify-center p-6 text-center">
                <h2 className="text-2xl font-bold mb-4">Session Not Found</h2>
                <p className="text-gray-400 mb-8">Please sign in again.</p>
                <button
                    onClick={async () => {
                        await supabase.auth.signOut();
                        router.push("/startup/dashboard/login");
                    }}
                    className="bg-white text-black px-8 py-3 font-bold uppercase tracking-widest hover:bg-gray-200 transition-colors text-xs"
                >
                    Return to Login
                </button>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-black text-white flex font-sans selection:bg-white selection:text-black">
            {/* Sidebar / Progress */}
            <div className="hidden md:flex w-1/3 border-r border-white/10 flex-col p-12 justify-between relative bg-[#050505]">
                <div className="flex items-center gap-2 mb-12">
                    <div className="w-8 h-8 bg-white flex items-center justify-center">
                        <Code2 className="w-4 h-4 text-black" />
                    </div>
                    <span className="font-bold tracking-tight">DEVAPP_INC</span>
                </div>

                <div className="space-y-8 relative z-10">
                    <div>
                        <h1 className="text-4xl font-bold tracking-tighter mb-4 leading-tight">
                            Initialize Your <br /> Organization.
                        </h1>
                        <p className="text-gray-500 max-w-sm">
                            Configure your startup profile to begin delegating engineering tasks to the network.
                        </p>
                    </div>

                    <div className="flex flex-col gap-4">
                        <div className={`flex items-center gap-4 transition-opacity ${step >= 1 ? 'opacity-100' : 'opacity-40'}`}>
                            <div className={`w-8 h-8 rounded-full border flex items-center justify-center text-xs font-mono ${step > 1 ? 'bg-white text-black border-white' : 'border-white/20 text-white'}`}>
                                {step > 1 ? <Check className="w-4 h-4" /> : "01"}
                            </div>
                            <span className="font-bold text-sm tracking-wide">Company Identity</span>
                        </div>
                        <div className={`flex items-center gap-4 transition-opacity ${step >= 2 ? 'opacity-100' : 'opacity-40'}`}>
                            <div className={`w-8 h-8 rounded-full border flex items-center justify-center text-xs font-mono ${step > 2 ? 'bg-white text-black border-white' : 'border-white/20 text-white'}`}>
                                {step > 2 ? <Check className="w-4 h-4" /> : "02"}
                            </div>
                            <span className="font-bold text-sm tracking-wide">Your Role</span>
                        </div>
                    </div>
                </div>

                <div className="text-xs text-gray-600 font-mono uppercase tracking-widest">
                    Steps {step} of 2
                </div>
            </div>

            {/* Main Form Area */}
            <div className="flex-1 flex flex-col justify-center p-8 md:p-24 relative overflow-hidden">
                {/* Background Grid */}
                <div className="absolute inset-0 bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px] pointer-events-none"></div>

                <div className="max-w-xl w-full mx-auto relative z-10">
                    <motion.div
                        key={step}
                        initial={{ opacity: 0, x: 20 }}
                        animate={{ opacity: 1, x: 0 }}
                        exit={{ opacity: 0, x: -20 }}
                        transition={{ duration: 0.4 }}
                    >
                        {step === 1 && (
                            <div className="space-y-6">
                                <div>
                                    <label className="block text-xs font-bold text-gray-500 uppercase tracking-widest mb-3">Company Name</label>
                                    <input
                                        autoFocus
                                        type="text"
                                        value={companyName}
                                        onChange={(e) => setCompanyName(e.target.value)}
                                        className="w-full bg-transparent border-b border-white/20 text-3xl font-bold py-2 focus:outline-none focus:border-white transition-colors placeholder:text-gray-800"
                                        placeholder="Acme Inc."
                                    />
                                </div>
                                <div>
                                    <label className="block text-xs font-bold text-gray-500 uppercase tracking-widest mb-3">Website (Optional)</label>
                                    <input
                                        type="text"
                                        value={website}
                                        onChange={(e) => setWebsite(e.target.value)}
                                        className="w-full bg-transparent border-b border-white/20 text-xl py-2 focus:outline-none focus:border-white transition-colors placeholder:text-gray-800 font-mono"
                                        placeholder="https://acme.com"
                                    />
                                </div>
                                <div className="pt-4">
                                    <label className="block text-xs font-bold text-gray-500 uppercase tracking-widest mb-3">Short Description</label>
                                    <textarea
                                        value={description}
                                        onChange={(e) => setDescription(e.target.value)}
                                        className="w-full bg-transparent border-b border-white/20 text-xl py-2 focus:outline-none focus:border-white transition-colors placeholder:text-gray-800 font-mono resize-none"
                                        placeholder="We are building the next generation of..."
                                        rows={2}
                                    />
                                </div>
                                <div className="pt-8 flex justify-end">
                                    <button
                                        onClick={() => {
                                            if (companyName && description) setStep(2);
                                        }}
                                        disabled={!companyName || !description}
                                        className="bg-white text-black px-8 py-3 font-bold uppercase tracking-widest hover:bg-gray-200 transition-colors flex items-center gap-2 disabled:opacity-50"
                                    >
                                        Continue <ArrowRight className="w-4 h-4" />
                                    </button>
                                </div>
                            </div>
                        )}

                        {step === 2 && (
                            <div className="space-y-8">
                                <div>
                                    <label className="block text-xs font-bold text-gray-500 uppercase tracking-widest mb-4">What is your role?</label>
                                    <div className="grid grid-cols-2 gap-4">
                                        {["Founder", "Co-Founder", "CTO", "Head of Product", "Product Manager", "Engineering Lead"].map((r) => (
                                            <button
                                                key={r}
                                                onClick={() => setRole(r)}
                                                className={`p-4 border text-left transition-colors ${role === r ? 'bg-white text-black border-white' : 'border-white/10 hover:border-white/50 bg-black'}`}
                                            >
                                                <span className="font-bold text-sm block">{r}</span>
                                            </button>
                                        ))}
                                    </div>
                                </div>

                                <div>
                                    <label className="block text-xs font-bold text-gray-500 uppercase tracking-widest mb-4">Current Team Size</label>
                                    <div className="flex gap-4">
                                        {["1-10", "11-50", "50+"].map((s) => (
                                            <button
                                                key={s}
                                                onClick={() => setTeamSize(s)}
                                                className={`px-6 py-3 border text-sm font-mono transition-colors ${teamSize === s ? 'bg-white text-black border-white' : 'border-white/10 hover:border-white/50 bg-black'}`}
                                            >
                                                {s}
                                            </button>
                                        ))}
                                    </div>
                                </div>

                                <div className="pt-8 flex justify-between items-center">
                                    <button
                                        onClick={() => setStep(1)}
                                        className="text-gray-500 hover:text-white text-xs font-bold uppercase tracking-widest"
                                    >
                                        Back
                                    </button>
                                    <button
                                        onClick={handleSubmit}
                                        disabled={!role || isLoading}
                                        className="bg-white text-black px-8 py-3 font-bold uppercase tracking-widest hover:bg-gray-200 transition-colors flex items-center gap-2 disabled:opacity-50"
                                    >
                                        {isLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : "Complete Setup"}
                                    </button>
                                </div>
                            </div>
                        )}
                    </motion.div>
                </div>
            </div >
            {/* Safe Logout for Stuck Users */}
            < div className="absolute bottom-6 right-6 z-50" >
                <button
                    onClick={async () => {
                        await supabase.auth.signOut();
                        router.push("/startup/dashboard/login");
                    }}
                    className="text-[10px] text-gray-700 hover:text-red-500 uppercase tracking-widest font-bold transition-colors"
                >
                    Force Sign Out
                </button>
            </div >
        </div >
    );
}
