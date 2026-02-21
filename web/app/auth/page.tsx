"use client";

import { Code2, Terminal, Shield, ArrowRight, Github, Mail, Loader2, AlertCircle } from "lucide-react";
import Link from "next/link";
import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import { useRouter, useSearchParams } from "next/navigation";

export default function AuthPage() {
    const [isLoading, setIsLoading] = useState(false);
    const [mode, setMode] = useState<"login" | "signup">("login");
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [fullName, setFullName] = useState("");
    const [username, setUsername] = useState("");
    const [error, setError] = useState<string | null>(null);
    const [message, setMessage] = useState<string | null>(null);

    const supabase = createClient();
    const router = useRouter();
    const searchParams = useSearchParams();

    const [conflict, setConflict] = useState<{ type: 'startup' | 'talent', message: string } | null>(null);
    const [isCheckingSession, setIsCheckingSession] = useState(true);

    useEffect(() => {
        const view = searchParams.get("view");
        const roleIntent = searchParams.get("role"); // 'talent' or 'startup'
        if (view === "signup") setMode("signup");

        const errorMsg = searchParams.get("error");
        if (errorMsg) setError(errorMsg);

        const msg = searchParams.get("message");
        if (msg) setMessage(msg);

        // Check for existing session
        const checkSession = async () => {
            const { data: { user } } = await supabase.auth.getUser();
            if (user) {
                // Fetch Profile Role
                const { data: profile } = await supabase.from('profiles').select('role').eq('id', user.id).single();
                const dbRole = profile?.role;
                const metaRole = user.user_metadata?.user_type;

                const STARTUP_ROLES = ['Founder', 'Co-Founder', 'CTO', 'VP of Engineering', 'Head of Product', 'Product Manager', 'Engineering Lead'];
                const isStartup = (dbRole && STARTUP_ROLES.includes(dbRole)) || metaRole === 'startup';
                const isTalent = !isStartup; // Simplified for this context, strict check would be dbRole not in array

                // RULE 3: HARD ROLE BOUNDARY CHECK
                if (roleIntent === 'talent' && isStartup) {
                    setConflict({ type: 'startup', message: "You are logged in as a Startup." });
                    setIsCheckingSession(false);
                    return;
                }

                if (roleIntent === 'startup' && isTalent) {
                    setConflict({ type: 'talent', message: "You are logged in as Talent." });
                    setIsCheckingSession(false);
                    return;
                }

                // If no conflict (or no intent specified), redirect to correct dashboard
                if (isStartup) {
                    router.replace("/startup/dashboard");
                } else {
                    router.replace("/talent/dashboard");
                }
            } else {
                setIsCheckingSession(false);
            }
        };
        checkSession();
    }, [searchParams, router, supabase]);

    if (isCheckingSession) {
        return (
            <div className="min-h-screen bg-black flex items-center justify-center">
                <div className="w-6 h-6 border-t-2 border-white rounded-full animate-spin"></div>
            </div>
        );
    }

    if (conflict) {
        return (
            <div className="min-h-screen bg-black text-white flex flex-col items-center justify-center p-6 text-center">
                <div className="max-w-md w-full bg-[#111] border border-white/10 p-8 rounded-xl shadow-2xl">
                    <AlertCircle className="w-12 h-12 text-yellow-500 mx-auto mb-4" />
                    <h2 className="text-xl font-bold mb-2">Account Conflict</h2>
                    <p className="text-gray-400 mb-6 text-sm">
                        {conflict.message} To continue as <span className="text-white font-bold">{searchParams.get("role") === 'talent' ? 'Developer' : 'Startup'}</span>, you must switch accounts.
                    </p>
                    <div className="flex flex-col gap-3">
                        <button
                            onClick={async () => {
                                await supabase.auth.signOut();
                                window.location.reload();
                            }}
                            className="w-full bg-white text-black font-bold uppercase tracking-widest py-3 hover:bg-gray-200 transition-colors text-xs"
                        >
                            Log Out & Switch
                        </button>
                        <Link href={conflict.type === 'startup' ? "/startup/dashboard" : "/talent/dashboard"} className="text-xs text-gray-500 hover:text-white uppercase tracking-widest py-2">
                            Continue to {conflict.type === 'startup' ? "Startup" : "Talent"} Dashboard
                        </Link>
                    </div>
                </div>
            </div>
        )
    }

    const handleAuth = async (e: React.FormEvent) => {
        e.preventDefault();
        setIsLoading(true);
        setError(null);
        setMessage(null);

        try {
            if (mode === "signup") {
                const { data, error } = await supabase.auth.signUp({
                    email,
                    password,
                    options: {
                        emailRedirectTo: `${window.location.origin}/auth/callback`,
                        data: {
                            full_name: fullName,
                            username: username,
                            user_type: 'talent', // Default to talent/developer for this generic auth page
                        }
                    }
                });

                if (error) throw error;

                if (data.user && !data.session) {
                    setMessage("Check your email for the confirmation link.");
                } else {
                    router.push("/onboarding");
                }
            } else {
                const { error } = await supabase.auth.signInWithPassword({
                    email,
                    password,
                });

                if (error) throw error;

                // Redirect logic is handled by middleware mostly, but good to push
                // Check if profile exists logic could happen here but usually better to rely on redirect
                router.refresh();
                router.push("/dashboard");
            }
        } catch (err: unknown) {
            if (err instanceof Error) {
                setError(err.message);
            } else {
                setError("An unexpected error occurred");
            }
        } finally {
            setIsLoading(false);
        }
    };

    const handleOAuth = async (provider: 'github' | 'google') => {
        setIsLoading(true);
        try {
            const { error } = await supabase.auth.signInWithOAuth({
                provider,
                options: {
                    redirectTo: `${window.location.origin}/auth/callback`,
                }
            });
            if (error) throw error;
        } catch (err: unknown) {
            if (err instanceof Error) {
                setError(err.message);
            } else {
                setError("An unexpected error occurred");
            }
            setIsLoading(false);
        }
    };

    return (
        <div className="min-h-screen bg-black text-white flex flex-col items-center justify-center p-6 relative overflow-hidden font-sans selection:bg-white selection:text-black">
            {/* Background Noise */}
            <div className="absolute inset-0 bg-[rgba(255,255,255,0.02)] pointer-events-none"></div>
            <div className="absolute inset-0 bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px] pointer-events-none"></div>

            <div className="w-full max-w-md relative z-10">
                <div className="text-center mb-10">
                    <Link href="/" className="inline-flex items-center gap-2 mb-6 group">
                        <div className="w-8 h-8 bg-white flex items-center justify-center">
                            <Code2 className="w-4 h-4 text-black" />
                        </div>
                        <span className="font-bold text-lg tracking-tight text-white uppercase group-hover:text-gray-300 transition-colors">DevApp_Inc.</span>
                    </Link>
                    <h2 className="text-3xl font-bold tracking-tighter mb-2">Protocol Access</h2>
                    <p className="text-gray-500 font-mono text-xs uppercase tracking-widest">
                        {mode === "login" ? "Identify Yourself" : "Initialize New Node"}
                    </p>
                </div>

                <div className="bg-[#111] border border-white/10 p-8 rounded-xl shadow-2xl relative overflow-hidden">
                    {/* Decorative top bar */}
                    <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-green-500 via-transparent to-transparent"></div>

                    {error && (
                        <div className="mb-6 p-4 bg-red-500/10 border border-red-500/20 text-red-500 text-xs font-mono flex items-start gap-2 rounded">
                            <AlertCircle className="w-4 h-4 mt-0.5 shrink-0" />
                            <span>{error}</span>
                        </div>
                    )}

                    {message && (
                        <div className="mb-6 p-4 bg-green-500/10 border border-green-500/20 text-green-500 text-xs font-mono flex items-start gap-2 rounded">
                            <Shield className="w-4 h-4 mt-0.5 shrink-0" />
                            <span>{message}</span>
                        </div>
                    )}

                    <form onSubmit={handleAuth} className="space-y-6">
                        {mode === "signup" && (
                            <div className="space-y-4 animate-in slide-in-from-top-4 fade-in duration-300">
                                <div>
                                    <label htmlFor="fullName" className="block text-xs font-bold text-gray-500 uppercase tracking-widest mb-2">Full Name</label>
                                    <input
                                        id="fullName"
                                        type="text"
                                        value={fullName}
                                        onChange={(e) => setFullName(e.target.value)}
                                        required
                                        className="w-full bg-black border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                        placeholder="Alex Developer"
                                    />
                                </div>
                                <div>
                                    <label htmlFor="username" className="block text-xs font-bold text-gray-500 uppercase tracking-widest mb-2">Username</label>
                                    <input
                                        id="username"
                                        type="text"
                                        value={username}
                                        onChange={(e) => setUsername(e.target.value)}
                                        required
                                        className="w-full bg-black border border-white/10 text-white px-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                        placeholder="alex_dev"
                                    />
                                </div>
                            </div>
                        )}

                        <div className="space-y-4">
                            <div>
                                <label htmlFor="email" className="block text-xs font-bold text-gray-500 uppercase tracking-widest mb-2">Identifier / Email</label>
                                <div className="relative">
                                    <div className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-600">
                                        <Terminal className="w-4 h-4" />
                                    </div>
                                    <input
                                        id="email"
                                        type="email"
                                        value={email}
                                        onChange={(e) => setEmail(e.target.value)}
                                        required
                                        className="w-full bg-black border border-white/10 text-white pl-12 pr-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                        placeholder="user@protocol.net"
                                    />
                                </div>
                            </div>
                            <div>
                                <div className="flex justify-between mb-2">
                                    <label htmlFor="password" className="block text-xs font-bold text-gray-500 uppercase tracking-widest">Keyphrase</label>
                                    {mode === "login" && (
                                        <Link href="/auth/forgot-password" className="text-[10px] text-gray-600 hover:text-white transition-colors uppercase tracking-widest">Lost Key?</Link>
                                    )}
                                </div>

                                <div className="relative">
                                    <div className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-600">
                                        <Shield className="w-4 h-4" />
                                    </div>
                                    <input
                                        id="password"
                                        type="password"
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                        required
                                        className="w-full bg-black border border-white/10 text-white pl-12 pr-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                        placeholder="••••••••••••"
                                        minLength={6}
                                    />
                                </div>
                            </div>
                        </div>

                        <button
                            type="submit"
                            disabled={isLoading}
                            className="w-full bg-white text-black font-bold uppercase tracking-widest py-4 hover:bg-gray-200 transition-colors text-xs flex items-center justify-center gap-2 group disabled:opacity-50"
                        >
                            {isLoading ? (
                                <>
                                    <Loader2 className="w-4 h-4 animate-spin" />
                                    <span>Processing...</span>
                                </>
                            ) : (
                                <>
                                    {mode === "login" ? "Establish Session" : "Initialize Node"}
                                    <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                                </>
                            )}
                        </button>

                        <div className="relative">
                            <div className="absolute inset-0 flex items-center">
                                <div className="w-full border-t border-white/10"></div>
                            </div>
                            <div className="relative flex justify-center text-xs uppercase">
                                <span className="bg-[#111] px-2 text-gray-500">Or authenticate via</span>
                            </div>
                        </div>

                        <div className="flex flex-col gap-4">
                            <button
                                type="button"
                                onClick={() => handleOAuth('github')}
                                disabled={isLoading}
                                className="w-full flex items-center justify-center gap-2 bg-black border border-white/10 py-3 hover:border-white transition-colors text-xs font-bold uppercase tracking-widest"
                            >
                                <Github className="w-4 h-4" />
                                <span>GitHub</span>
                            </button>
                        </div>
                    </form>
                </div>

                <div className="text-center mt-8">
                    <p className="text-xs text-gray-600">
                        {mode === "login" ? (
                            <>
                                New to the protocol? <button onClick={() => setMode("signup")} className="text-white underline underline-offset-4 decoration-white/30 hover:decoration-white">Request Invite</button>
                            </>
                        ) : (
                            <>
                                Already have a handle? <button onClick={() => setMode("login")} className="text-white underline underline-offset-4 decoration-white/30 hover:decoration-white">Establish Session</button>
                            </>
                        )}
                    </p>
                </div>
            </div>
        </div>
    );
}
