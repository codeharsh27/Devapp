"use client";

import { Mail, MessageCircle, FileQuestion, ExternalLink } from "lucide-react";

export function SupportView() {
    return (
        <div className="max-w-4xl mx-auto p-8 text-white animate-in fade-in duration-500">
            <h1 className="text-3xl font-light mb-2">Support & Help</h1>
            <p className="text-zinc-400 mb-8">We're here to help you get the most out of DevApp.</p>

            <div className="grid md:grid-cols-2 gap-8">
                {/* Contact Section */}
                <div className="bg-[#111113] border border-zinc-800 rounded-2xl p-8 space-y-6">
                    <div className="w-12 h-12 rounded-full bg-indigo-500/10 flex items-center justify-center text-indigo-400">
                        <Mail className="w-6 h-6" />
                    </div>
                    <div>
                        <h2 className="text-xl font-bold text-white mb-2">Contact Support</h2>
                        <p className="text-zinc-400 text-sm leading-relaxed mb-6">
                            Running into issues or have specific questions about your account? Our team is ready to assist you.
                        </p>
                        <a href="mailto:support@devapp.inc" className="inline-flex items-center gap-2 bg-white text-black px-6 py-3 rounded-lg font-bold hover:bg-zinc-200 transition-colors">
                            <Mail className="w-4 h-4" /> Email Support
                        </a>
                    </div>
                </div>

                {/* Community Section */}
                <div className="bg-[#111113] border border-zinc-800 rounded-2xl p-8 space-y-6">
                    <div className="w-12 h-12 rounded-full bg-emerald-500/10 flex items-center justify-center text-emerald-400">
                        <MessageCircle className="w-6 h-6" />
                    </div>
                    <div>
                        <h2 className="text-xl font-bold text-white mb-2">Join the Community</h2>
                        <p className="text-zinc-400 text-sm leading-relaxed mb-6">
                            Connect with other founders and developers. Share tips, ask questions, and build together.
                        </p>
                        <div className="flex gap-3">
                            <button className="flex-1 bg-zinc-800 hover:bg-zinc-700 text-white py-3 rounded-lg font-medium transition-colors flex items-center justify-center gap-2">
                                Discord <ExternalLink className="w-4 h-4 text-zinc-500" />
                            </button>
                            <button className="flex-1 bg-zinc-800 hover:bg-zinc-700 text-white py-3 rounded-lg font-medium transition-colors flex items-center justify-center gap-2">
                                Twitter <ExternalLink className="w-4 h-4 text-zinc-500" />
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            {/* FAQ Preview */}
            <div className="mt-12">
                <h3 className="text-xl font-bold text-white mb-6 flex items-center gap-2">
                    <FileQuestion className="w-5 h-5 text-zinc-500" /> Frequently Asked Questions
                </h3>
                <div className="grid gap-4">
                    {[
                        { q: "How do I create a new mission?", a: "Navigate to the Dashboard and click the 'New Mission' button in the sidebar." },
                        { q: "When do I pay the bounty?", a: "Bounties are paid out only after you successfully evaluate and accept a submission." },
                        { q: "Can I edit a mission after posting?", a: "Yes, you can edit mission details from the mission drawer before it has any active submissions." }
                    ].map((faq, i) => (
                        <div key={i} className="bg-zinc-900/30 border border-zinc-800 rounded-xl p-6">
                            <h4 className="font-bold text-white mb-2">{faq.q}</h4>
                            <p className="text-zinc-400 text-sm">{faq.a}</p>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
}
