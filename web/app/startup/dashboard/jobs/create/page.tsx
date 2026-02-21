"use client";
import { useState } from "react";
import { Space_Grotesk } from "next/font/google";
import {
    Github, ExternalLink, Code2, Terminal, AlertCircle,
    CheckCircle2, ArrowRight, DollarSign, Clock, Layout, FileCode
} from "lucide-react";
import Link from "next/link";
import { supabase } from "@/lib/supabaseClient";
import { useRouter } from "next/navigation";

const spaceGrotesk = Space_Grotesk({
    subsets: ["latin"],
    weight: ["300", "400", "500", "600"],
});

type Step = 'repo' | 'context' | 'validation' | 'bounty';

export default function CreateMissionPage() {
    const [currentStep, setCurrentStep] = useState<Step>('repo');
    const [isLoading, setIsLoading] = useState(false);

    // Form State
    const [formData, setFormData] = useState({
        repoUrl: "",
        branch: "main",
        isPrivate: true,
        title: "",
        description: "",
        files: "",
        testCommand: "npm test",
        bounty: "",
        deadline: "3 days"
    });

    const handleNext = () => {
        if (currentStep === 'repo') setCurrentStep('context');
        else if (currentStep === 'context') setCurrentStep('validation');
        else if (currentStep === 'validation') setCurrentStep('bounty');
    };

    const handleBack = () => {
        if (currentStep === 'bounty') setCurrentStep('validation');
        else if (currentStep === 'validation') setCurrentStep('context');
        else if (currentStep === 'context') setCurrentStep('repo');
    };

    const router = useRouter();

    const handleSubmit = async () => {
        setIsLoading(true);

        try {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) throw new Error("Please login first");

            const { error } = await supabase
                .from('missions')
                .insert([{
                    title: formData.title,
                    description: formData.description,
                    repo_url: formData.repoUrl,
                    branch_name: formData.branch,
                    test_command: formData.testCommand,
                    bounty: parseInt(formData.bounty),
                    status: 'Open',
                    category: 'Backend', // Default for now
                    user_id: user.id,
                    is_private: formData.isPrivate,
                    relevant_files: formData.files.split(',').map(f => f.trim()).filter(f => f)
                }]);

            if (error) throw error;

            alert("Mission Created! The Mission Box is being provisioned.");
            router.push('/dashboard/startup');

        } catch (error: any) {
            alert(error.message);
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div className="min-h-screen bg-[#000000] text-zinc-200 font-sans selection:bg-indigo-500/30">

            {/* Header */}
            <div className="border-b border-zinc-900 bg-[#0c0c0e]/50 backdrop-blur-xl sticky top-0 z-50">
                <div className="max-w-5xl mx-auto px-6 h-16 flex items-center justify-between">
                    <div className="flex items-center gap-4">
                        <Link href="/dashboard/startup" className="text-zinc-500 hover:text-white transition-colors text-sm">
                            ← Back to Dashboard
                        </Link>
                        <span className="text-zinc-800">|</span>
                        <h1 className={`text-lg font-medium text-white ${spaceGrotesk.className}`}>Create New Mission</h1>
                    </div>
                    {/* Step Indicator */}
                    <div className="flex items-center gap-2">
                        {['repo', 'context', 'validation', 'bounty'].map((step, idx) => (
                            <div key={step} className={`flex items-center gap-2 ${currentStep === step ? 'text-indigo-400' : 'text-zinc-600'}`}>
                                <span className={`text-xs font-bold uppercase tracking-wider ${currentStep === step ? 'text-indigo-400' : 'text-zinc-700'}`}>
                                    0{idx + 1} {step}
                                </span>
                                {idx < 3 && <div className="w-4 h-[1px] bg-zinc-800"></div>}
                            </div>
                        ))}
                    </div>
                </div>
            </div>

            <main className="max-w-3xl mx-auto px-6 py-12">
                <div className="bg-[#0c0c0e] border border-zinc-800 rounded-2xl overflow-hidden shadow-2xl">

                    {/* Step 1: The Repository Source */}
                    {currentStep === 'repo' && (
                        <div className="p-8 animate-in fade-in slide-in-from-right-4 duration-300">
                            <h2 className={`text-3xl font-light text-white mb-2 ${spaceGrotesk.className}`}>Where is the code?</h2>
                            <p className="text-zinc-400 mb-8">Link the repository containing the issue. We will create a secure, isolated fork for the developer.</p>

                            <div className="space-y-6">
                                <div>
                                    <label className="block text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Repository URL</label>
                                    <div className="relative">
                                        <Github className="absolute left-4 top-3.5 w-5 h-5 text-zinc-500" />
                                        <input
                                            value={formData.repoUrl}
                                            onChange={(e) => setFormData({ ...formData, repoUrl: e.target.value })}
                                            placeholder="https://github.com/your-org/repo-name"
                                            className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl py-3 pl-12 pr-4 text-white focus:outline-none focus:border-indigo-500 transition-colors"
                                        />
                                    </div>
                                </div>

                                <div className="grid grid-cols-2 gap-6">
                                    <div>
                                        <label className="block text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Branch</label>
                                        <div className="relative">
                                            <Code2 className="absolute left-4 top-3.5 w-5 h-5 text-zinc-500" />
                                            <input
                                                value={formData.branch}
                                                onChange={(e) => setFormData({ ...formData, branch: e.target.value })}
                                                placeholder="main"
                                                className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl py-3 pl-12 pr-4 text-white focus:outline-none focus:border-indigo-500 transition-colors"
                                            />
                                        </div>
                                    </div>
                                    <div>
                                        <label className="block text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Visibility</label>
                                        <div className="flex bg-zinc-900/50 border border-zinc-800 rounded-xl p-1">
                                            <button
                                                onClick={() => setFormData({ ...formData, isPrivate: true })}
                                                className={`flex-1 py-2 text-sm font-medium rounded-lg transition-all ${formData.isPrivate ? 'bg-zinc-800 text-white shadow-sm' : 'text-zinc-500 hover:text-zinc-300'}`}
                                            >
                                                Private
                                            </button>
                                            <button
                                                onClick={() => setFormData({ ...formData, isPrivate: false })}
                                                className={`flex-1 py-2 text-sm font-medium rounded-lg transition-all ${!formData.isPrivate ? 'bg-zinc-800 text-white shadow-sm' : 'text-zinc-500 hover:text-zinc-300'}`}
                                            >
                                                Public
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div className="bg-indigo-500/10 border border-indigo-500/20 p-4 rounded-xl flex gap-3 items-start">
                                    <AlertCircle className="w-5 h-5 text-indigo-400 shrink-0 mt-0.5" />
                                    <div>
                                        <h4 className="text-sm font-bold text-indigo-400 mb-1">Security Guarantee</h4>
                                        <p className="text-xs text-zinc-400">Developers work in a sandboxed, ephemeral fork. They do not get direct write access to your main repository.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Step 2: The Context (Scope) */}
                    {currentStep === 'context' && (
                        <div className="p-8 animate-in fade-in slide-in-from-right-4 duration-300">
                            <h2 className={`text-3xl font-light text-white mb-2 ${spaceGrotesk.className}`}>Define the Mission</h2>
                            <p className="text-zinc-400 mb-8">What exactly needs to be fixed or built? Be specific about the scope.</p>

                            <div className="space-y-6">
                                <div>
                                    <label className="block text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Mission Title</label>
                                    <input
                                        value={formData.title}
                                        onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                                        placeholder="e.g. Fix Auth Token Expiry Bug"
                                        className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl py-3 px-4 text-white focus:outline-none focus:border-indigo-500 transition-colors"
                                    />
                                </div>

                                <div>
                                    <label className="block text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Issue Description / Instructions</label>
                                    <textarea
                                        value={formData.description}
                                        onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                                        placeholder="Describe the bug, expected behavior, and reproduction steps..."
                                        rows={6}
                                        className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl py-3 px-4 text-white focus:outline-none focus:border-indigo-500 transition-colors resize-none"
                                    />
                                </div>

                                <div>
                                    <label className="block text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Relevant Files (Optional)</label>
                                    <div className="relative">
                                        <FileCode className="absolute left-4 top-3.5 w-5 h-5 text-zinc-500" />
                                        <input
                                            value={formData.files}
                                            onChange={(e) => setFormData({ ...formData, files: e.target.value })}
                                            placeholder="src/auth/GoogleAuth.ts, tests/auth.spec.ts"
                                            className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl py-3 pl-12 pr-4 text-white focus:outline-none focus:border-indigo-500 transition-colors"
                                        />
                                    </div>
                                    <p className="text-[10px] text-zinc-500 mt-2 ml-1">Comma separated. We highlight these for the developer.</p>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Step 3: The Validation (Tests) */}
                    {currentStep === 'validation' && (
                        <div className="p-8 animate-in fade-in slide-in-from-right-4 duration-300">
                            <h2 className={`text-3xl font-light text-white mb-2 ${spaceGrotesk.className}`}>Success Criteria</h2>
                            <p className="text-zinc-400 mb-8">How do we know the mission is complete? Define the automated test.</p>

                            <div className="space-y-6">
                                <div className="bg-zinc-900/30 border border-zinc-800 rounded-xl p-6">
                                    <h3 className="text-sm font-bold text-zinc-300 mb-4 flex items-center gap-2">
                                        <Terminal className="w-4 h-4 text-indigo-400" /> Validation Command
                                    </h3>
                                    <p className="text-xs text-zinc-500 mb-4">Enter the command the CI/CD pipeline should run to verify the fix.</p>

                                    <div className="font-mono text-sm bg-black border border-zinc-800 rounded-lg p-4 text-emerald-400 flex items-center gap-2">
                                        <span className="text-zinc-600">$</span>
                                        <input
                                            value={formData.testCommand}
                                            onChange={(e) => setFormData({ ...formData, testCommand: e.target.value })}
                                            className="bg-transparent border-none outline-none w-full text-emerald-400 placeholder:text-zinc-700"
                                            placeholder="npm test tests/auth.spec.ts"
                                        />
                                    </div>
                                </div>

                                <div className="bg-amber-500/10 border border-amber-500/20 p-4 rounded-xl">
                                    <h4 className="text-sm font-bold text-amber-400 mb-2">Automated Payout Trigger</h4>
                                    <p className="text-xs text-zinc-400 leading-relaxed">
                                        When a developer submits code, our system runs this command. <br />
                                        If it PASSES (Exit Code 0), the submission is marked as <strong>Valid</strong> automatically.
                                    </p>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Step 4: The Bounty (Money) */}
                    {currentStep === 'bounty' && (
                        <div className="p-8 animate-in fade-in slide-in-from-right-4 duration-300">
                            <h2 className={`text-3xl font-light text-white mb-2 ${spaceGrotesk.className}`}>Set the Bounty</h2>
                            <p className="text-zinc-400 mb-8">Define the reward and timeline for this mission.</p>

                            <div className="space-y-8">
                                <div className="grid grid-cols-2 gap-6">
                                    <div>
                                        <label className="block text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Total Bounty (USD)</label>
                                        <div className="relative">
                                            <DollarSign className="absolute left-4 top-3.5 w-5 h-5 text-zinc-500" />
                                            <input
                                                type="number"
                                                value={formData.bounty}
                                                onChange={(e) => setFormData({ ...formData, bounty: e.target.value })}
                                                placeholder="500"
                                                className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl py-3 pl-12 pr-4 text-white text-lg font-mono focus:outline-none focus:border-indigo-500 transition-colors"
                                            />
                                        </div>
                                    </div>
                                    <div>
                                        <label className="block text-xs font-bold text-zinc-500 uppercase tracking-wider mb-2">Deadline</label>
                                        <div className="relative">
                                            <Clock className="absolute left-4 top-3.5 w-5 h-5 text-zinc-500" />
                                            <input
                                                value={formData.deadline}
                                                onChange={(e) => setFormData({ ...formData, deadline: e.target.value })}
                                                placeholder="e.g. 3 days"
                                                className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl py-3 pl-12 pr-4 text-white focus:outline-none focus:border-indigo-500 transition-colors"
                                            />
                                        </div>
                                    </div>
                                </div>

                                <div className="bg-zinc-900/50 p-6 rounded-xl border border-zinc-800">
                                    <h4 className="text-sm font-bold text-zinc-300 mb-4">Summary</h4>
                                    <ul className="space-y-3 text-sm text-zinc-400">
                                        <li className="flex justify-between">
                                            <span>Repository</span>
                                            <span className="text-zinc-200 font-mono">{formData.repoUrl || 'No URL'}</span>
                                        </li>
                                        <li className="flex justify-between">
                                            <span>Validation</span>
                                            <span className="text-zinc-200 font-mono">{formData.testCommand}</span>
                                        </li>
                                        <li className="flex justify-between border-t border-zinc-800 pt-3 mt-3">
                                            <span>Est. Total</span>
                                            <span className="text-emerald-400 font-bold text-lg">${formData.bounty || '0'}</span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Navigation Footer */}
                    <div className="p-6 border-t border-zinc-800 bg-[#09090b] flex justify-between items-center">
                        {currentStep !== 'repo' ? (
                            <button
                                onClick={handleBack}
                                className="px-6 py-3 rounded-xl border border-zinc-800 hover:bg-zinc-800 text-zinc-400 transition-colors font-medium text-sm"
                            >
                                Back
                            </button>
                        ) : (
                            <div></div> // Spacer
                        )}

                        {currentStep === 'bounty' ? (
                            <button
                                onClick={handleSubmit}
                                disabled={isLoading || !formData.bounty}
                                className="bg-emerald-600 hover:bg-emerald-500 text-white px-8 py-3 rounded-xl font-bold flex items-center gap-2 transition-all shadow-lg shadow-emerald-900/20 disabled:opacity-50 disabled:cursor-not-allowed"
                            >
                                {isLoading ? 'Processing...' : 'Launch Mission'} <CheckCircle2 className="w-4 h-4" />
                            </button>
                        ) : (
                            <button
                                onClick={handleNext}
                                className="bg-white hover:bg-zinc-200 text-black px-8 py-3 rounded-xl font-bold flex items-center gap-2 transition-all shadow-lg"
                            >
                                Next Step <ArrowRight className="w-4 h-4" />
                            </button>
                        )}
                    </div>

                </div>
            </main>
        </div>
    );
}
