"use client";

import { Code2, Github, Chrome, Loader2, ArrowRight } from "lucide-react";
import Link from "next/link";
import { useState, useEffect, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

function StartupLoginPageInner() {
    const supabase = createClient();
    const [isLoading, setIsLoading] = useState(false);
    const [isSignUp, setIsSignUp] = useState(false);
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [fullName, setFullName] = useState("");
    const [error, setError] = useState<string | null>(null);
    const [confirmationMsg, setConfirmationMsg] = useState<string | null>(null);
    const [conflict, setConflict] = useState<{ type: 'startup' | 'talent', message: string } | null>(null);
    const [isCheckingSession, setIsCheckingSession] = useState(true);
    const router = useRouter();
    const searchParams = useSearchParams();

    useEffect(() => {
        const view = searchParams.get("view");
        const roleIntent = searchParams.get("role") || 'startup'; // Default to startup for this page
        if (view === "signup") setIsSignUp(true);

        // Check for existing session on mount
        const checkSession = async () => {
            const { data: { session } } = await supabase.auth.getSession();
            const user = session?.user;
            if (user && session) {
                // Fetch Profile Role
                const { fetchApi } = await import("@/lib/apiClient");
                const profile = await fetchApi<any>('/users/me', { token: session.access_token }).catch(() => null);
                const dbRole = profile?.role;
                const metaRole = user.user_metadata?.user_type;

                const STARTUP_ROLES = ['Founder', 'Co-Founder', 'CTO', 'VP of Engineering', 'Head of Product', 'Product Manager', 'Engineering Lead'];
                const isStartup = (dbRole && STARTUP_ROLES.includes(dbRole)) || metaRole === 'startup';
                const isTalent = !isStartup;

                // RULE 3: HARD ROLE BOUNDARY CHECK (Focus on preventing Talent from entering Startup flow)
                if (isTalent) {
                    setConflict({ type: 'talent', message: "You are logged in as Talent." });
                    setIsCheckingSession(false);
                    return;
                }

                // If is startup, allow redirection
                if (profile?.role) {
                    router.replace("/startup/dashboard");
                } else {
                    router.replace("/onboarding/startup");
                }
            } else {
                setIsCheckingSession(false);
            }
        };
        checkSession();
    }, [router, searchParams]);

    // ... (Keep existing handlers)

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
                    <h2 className="text-xl font-bold mb-2">Account Conflict</h2>
                    <p className="text-gray-400 mb-6 text-sm">
                        {conflict.message} To continue as <span className="text-white font-bold">Startup</span>, you must switch accounts.
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
                        <Link href="/talent/dashboard" className="text-xs text-gray-500 hover:text-white uppercase tracking-widest py-2">
                            Return to Talent Dashboard
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
        setConfirmationMsg(null);

        try {
            if (isSignUp) {
                const { data, error: signUpError } = await supabase.auth.signUp({
                    email,
                    password,
                    options: {
                        data: {
                            full_name: fullName,
                            user_type: 'startup'
                        }
                    }
                });

                if (signUpError) throw signUpError;

                if (data.session) {
                    router.push("/onboarding/startup");
                } else if (data.user) {
                    setConfirmationMsg("Account created! Please check your email to confirm.");
                    setIsSignUp(false);
                }
            } else {
                const { data, error: signInError } = await supabase.auth.signInWithPassword({
                    email,
                    password,
                });

                if (signInError) throw signInError;

                const user = data?.user;
                if (user && data?.session) {
                    const { fetchApi } = await import("@/lib/apiClient");
                    const profile = await fetchApi<any>('/users/me', { token: data.session.access_token }).catch(() => null);

                    if (!profile?.role) {
                        router.push("/onboarding/startup");
                    } else {
                        router.push("/dashboard");
                    }
                }
            }
        } catch (err: any) {
            console.error("Auth error:", err);
            setError(err.message || "Authentication failed.");
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
        } catch (err: any) {
            console.error("Auth error:", err);
            setError(err.message || "Authentication failed.");
            setIsLoading(false);
        }
    };

    if (isCheckingSession) {
        return (
            <div className="min-h-screen bg-black flex items-center justify-center">
                <div className="w-6 h-6 border-t-2 border-white rounded-full animate-spin"></div>
            </div>
        );
    }

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
                        <span className="font-bold text-lg tracking-tight text-white uppercase group-hover:text-gray-300 transition-colors">DevApp for Startups</span>
                    </Link>
                    <h2 className="text-3xl font-bold tracking-tighter mb-2">{!isSignUp ? "Welcome Back" : "Create Account"}</h2>
                    <p className="text-gray-500 font-mono text-xs uppercase tracking-widest">
                        {!isSignUp ? "Sign in to manage your team" : "Get started with DevApp"}
                    </p>
                </div>

                <div className="bg-[#111] border border-white/10 p-8 rounded-xl shadow-2xl relative overflow-hidden">
                    {/* Decorative top bar */}
                    <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-blue-500 via-transparent to-transparent"></div>

                    {error && (
                        <div className="mb-6 p-4 bg-red-500/10 border border-red-500/20 text-red-500 text-xs font-mono flex items-start gap-2 rounded">
                            <div className="w-4 h-4 mt-0.5 shrink-0 bg-red-500 rounded-full flex items-center justify-center text-black font-bold">!</div>
                            <span>{error}</span>
                        </div>
                    )}

                    {confirmationMsg && (
                        <div className="mb-6 p-4 bg-green-500/10 border border-green-500/20 text-green-500 text-xs font-mono flex items-start gap-2 rounded">
                            <div className="w-4 h-4 mt-0.5 shrink-0 bg-green-500 rounded-full flex items-center justify-center text-black font-bold">✓</div>
                            <span>{confirmationMsg}</span>
                        </div>
                    )}

                    <form onSubmit={handleAuth} className="space-y-6">
                        {isSignUp && (
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
                                        placeholder="John Doe"
                                    />
                                </div>
                            </div>
                        )}

                        <div className="space-y-4">
                            <div>
                                <label htmlFor="email" className="block text-xs font-bold text-gray-500 uppercase tracking-widest mb-2">Work Email</label>
                                <div className="relative">
                                    <div className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-600">
                                        <Code2 className="w-4 h-4" />
                                    </div>
                                    <input
                                        id="email"
                                        type="email"
                                        value={email}
                                        onChange={(e) => setEmail(e.target.value)}
                                        required
                                        className="w-full bg-black border border-white/10 text-white pl-12 pr-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                        placeholder="founder@company.com"
                                    />
                                </div>
                            </div>
                            <div>
                                <div className="flex justify-between mb-2">
                                    <label htmlFor="password" className="block text-xs font-bold text-gray-500 uppercase tracking-widest">Password</label>
                                    {!isSignUp && (
                                        <Link href="/auth/forgot-password" className="text-[10px] text-gray-600 hover:text-white transition-colors uppercase tracking-widest">Forgot Password?</Link>
                                    )}
                                </div>

                                <div className="relative">
                                    <div className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-600">
                                        <div className="w-4 h-4 border border-current rounded-sm flex items-center justify-center text-[10px]">#</div>
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
                                    <span>Loading...</span>
                                </>
                            ) : (
                                <>
                                    {!isSignUp ? "Log In" : "Sign Up"}
                                    <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                                </>
                            )}
                        </button>

                        <div className="relative">
                            <div className="absolute inset-0 flex items-center">
                                <div className="w-full border-t border-white/10"></div>
                            </div>
                            <div className="relative flex justify-center text-xs uppercase">
                                <span className="bg-[#111] px-2 text-gray-500">Or continue with</span>
                            </div>
                        </div>

                        <div className="flex flex-col gap-4">
                            <button
                                type="button"
                                onClick={() => handleOAuth('github')}
                                disabled={isLoading}
                                className="w-full flex items-center justify-center gap-2 bg-black border border-white/10 py-3 hover:border-white transition-colors text-xs font-bold uppercase tracking-widest group"
                            >
                                <Github className="w-4 h-4 text-gray-400 group-hover:text-white transition-colors" />
                                <span>GitHub</span>
                            </button>
                            <button
                                type="button"
                                onClick={() => handleOAuth('google')}
                                disabled={isLoading}
                                className="w-full flex items-center justify-center gap-2 bg-black border border-white/10 py-3 hover:border-white transition-colors text-xs font-bold uppercase tracking-widest group"
                            >
                                <Chrome className="w-4 h-4 text-gray-400 group-hover:text-white transition-colors" />
                                <span>Google</span>
                            </button>
                        </div>
                    </form>
                </div>

                <div className="text-center mt-8">
                    <p className="text-xs text-gray-600">
                        {!isSignUp ? (
                            <>
                                New to DevApp? <button onClick={() => setIsSignUp(true)} className="text-white underline underline-offset-4 decoration-white/30 hover:decoration-white">Create an account</button>
                            </>
                        ) : (
                            <>
                                Already have an account? <button onClick={() => setIsSignUp(false)} className="text-white underline underline-offset-4 decoration-white/30 hover:decoration-white">Log in</button>
                            </>
                        )}
                    </p>
                </div>
            </div>
        </div>
    );
}

export default function StartupLoginPage() {
    return (
        <Suspense fallback={
            <div className="min-h-screen bg-black flex items-center justify-center">
                <div className="w-6 h-6 border-t-2 border-white rounded-full animate-spin" />
            </div>
        }>
            <StartupLoginPageInner />
        </Suspense>
    );
}
