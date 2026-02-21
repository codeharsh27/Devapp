"use client";

import { Code2, Shield, Loader2, AlertCircle } from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";

export default function UpdatePasswordPage() {
    const [isLoading, setIsLoading] = useState(false);
    const [password, setPassword] = useState("");
    const [error, setError] = useState<string | null>(null);
    const supabase = createClient();
    const router = useRouter();

    const handleUpdate = async (e: React.FormEvent) => {
        e.preventDefault();
        setIsLoading(true);
        setError(null);

        try {
            const { error } = await supabase.auth.updateUser({
                password: password,
            });
            if (error) throw error;
            router.push("/dashboard");
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
                    <h2 className="text-3xl font-bold tracking-tighter mb-2">Secure New Key</h2>
                    <p className="text-gray-500 font-mono text-xs uppercase tracking-widest">Update Credentials</p>
                </div>

                <div className="bg-[#111] border border-white/10 p-8 rounded-xl shadow-2xl relative overflow-hidden">
                    <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-blue-500 via-transparent to-transparent"></div>

                    {error && (
                        <div className="mb-6 p-4 bg-red-500/10 border border-red-500/20 text-red-500 text-xs font-mono flex items-start gap-2 rounded">
                            <AlertCircle className="w-4 h-4 mt-0.5 shrink-0" />
                            <span>{error}</span>
                        </div>
                    )}

                    <form onSubmit={handleUpdate} className="space-y-6">
                        <div>
                            <label htmlFor="password" className="block text-xs font-bold text-gray-500 uppercase tracking-widest mb-2">New Keyphrase</label>
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
                                    minLength={6}
                                    className="w-full bg-black border border-white/10 text-white pl-12 pr-4 py-3 focus:outline-none focus:border-white transition-colors font-mono text-sm"
                                    placeholder="••••••••••••"
                                />
                            </div>
                        </div>

                        <button
                            type="submit"
                            disabled={isLoading}
                            className="w-full bg-white text-black font-bold uppercase tracking-widest py-4 hover:bg-gray-200 transition-colors text-xs flex items-center justify-center gap-2 group disabled:opacity-50"
                        >
                            {isLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : "Update Credentials"}
                        </button>
                    </form>
                </div>
            </div>
        </div>
    );
}
