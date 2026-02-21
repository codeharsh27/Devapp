"use client";

import { Code2, Terminal, Shield, ArrowRight, Loader2, AlertCircle, ArrowLeft } from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import { createClient } from "@/lib/supabase/client";

export default function ForgotPasswordPage() {
    const [isLoading, setIsLoading] = useState(false);
    const [email, setEmail] = useState("");
    const [error, setError] = useState<string | null>(null);
    const [success, setSuccess] = useState(false);

    const supabase = createClient();

    const handleReset = async (e: React.FormEvent) => {
        e.preventDefault();
        setIsLoading(true);
        setError(null);
        setSuccess(false);

        try {
            const { error } = await supabase.auth.resetPasswordForEmail(email, {
                redirectTo: `${window.location.origin}/auth/callback?next=/auth/update-password`,
            });
            if (error) throw error;
            setSuccess(true);
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
                    <h2 className="text-3xl font-bold tracking-tighter mb-2">Key Recovery</h2>
                    <p className="text-gray-500 font-mono text-xs uppercase tracking-widest">Restore Access Protocol</p>
                </div>

                <div className="bg-[#111] border border-white/10 p-8 rounded-xl shadow-2xl relative overflow-hidden">
                    <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-yellow-500 via-transparent to-transparent"></div>

                    {error && (
                        <div className="mb-6 p-4 bg-red-500/10 border border-red-500/20 text-red-500 text-xs font-mono flex items-start gap-2 rounded">
                            <AlertCircle className="w-4 h-4 mt-0.5 shrink-0" />
                            <span>{error}</span>
                        </div>
                    )}

                    {success ? (
                        <div className="text-center py-4">
                            <div className="w-16 h-16 bg-green-500/10 text-green-500 rounded-full flex items-center justify-center mx-auto mb-4 border border-green-500/20">
                                <Shield className="w-8 h-8" />
                            </div>
                            <h3 className="text-lg font-bold text-white mb-2">Recovery Initiated</h3>
                            <p className="text-gray-500 text-sm mb-6">If an account exists for {email}, you will receive a recovery link shortly.</p>
                            <Link href="/auth" className="text-xs font-bold uppercase tracking-widest text-white hover:text-gray-300 flex items-center justify-center gap-2">
                                <ArrowLeft className="w-4 h-4" /> Return to Login
                            </Link>
                        </div>
                    ) : (
                        <form onSubmit={handleReset} className="space-y-6">
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

                            <button
                                type="submit"
                                disabled={isLoading}
                                className="w-full bg-white text-black font-bold uppercase tracking-widest py-4 hover:bg-gray-200 transition-colors text-xs flex items-center justify-center gap-2 group disabled:opacity-50"
                            >
                                {isLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : "Initiate Recovery Sequence"}
                            </button>
                        </form>
                    )}
                </div>
                <div className="text-center mt-8">
                    <Link href="/auth" className="text-xs text-gray-600 hover:text-white transition-colors flex items-center justify-center gap-2">
                        <ArrowLeft className="w-3 h-3" /> Abort Sequence
                    </Link>
                </div>
            </div>
        </div>
    );
}
