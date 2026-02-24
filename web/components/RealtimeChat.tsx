
"use client";
import { useEffect, useState, useRef } from "react";
import { Send, Search, MoreHorizontal, Smile, Paperclip, Phone, Video, Info, Loader2 } from "lucide-react";
import { useChat } from "@/lib/hooks/useChat";
import { Skeleton } from "@/components/ui/Skeleton";

// Reusing your TalentMessages component structure but connecting hook
export function RealtimeChat({ userId, defaultConversationId }: { userId: string | undefined, defaultConversationId?: string | null }) {
    const {
        conversations,
        messages,
        activeConversationId,
        setActiveConversationId,
        sendMessage,
        loadingConvos,
        loadingMessages,
        error
    } = useChat(userId);

    // Set default conversation if provided
    useEffect(() => {
        if (defaultConversationId) {
            setActiveConversationId(defaultConversationId);
        }
    }, [defaultConversationId, setActiveConversationId]);

    const [inputText, setInputText] = useState("");
    const messagesEndRef = useRef<HTMLDivElement>(null);
    const audioRef = useRef<HTMLAudioElement | null>(null);

    // Scroll to bottom
    useEffect(() => {
        messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
    }, [messages]);

    // Play sound on new message (if not sender)
    useEffect(() => {
        const lastMsg = messages[messages.length - 1];
        if (lastMsg && lastMsg.sender_id !== userId) {
            // new Audio('/sounds/pop.mp3').play().catch(() => {}); // Optional
        }
    }, [messages, userId]);

    const handleSend = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!inputText.trim()) return;
        const text = inputText;
        setInputText(""); // Instant clear
        await sendMessage(text);
    };

    const activeConvo = conversations.find(c => c.id === activeConversationId);

    return (
        <div className="flex-1 flex h-full overflow-hidden bg-[#0c0c0e] animate-in fade-in duration-500 border border-zinc-800 rounded-2xl mx-1 my-1 shadow-2xl">

            {/* Sidebar List */}
            <div className="w-80 border-r border-zinc-800 flex flex-col bg-[#09090b]">
                <div className="p-4 border-b border-zinc-800">
                    <h2 className="text-xl font-light text-zinc-100 mb-4">Messages</h2>
                    <div className="relative">
                        <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-zinc-500" />
                        <input
                            placeholder="Search chats..."
                            className="w-full bg-[#18181b] border border-zinc-800 rounded-lg pl-9 pr-4 py-2 text-sm text-zinc-200 outline-none focus:border-zinc-700 transition-colors"
                        />
                    </div>
                </div>

                <div className="flex-1 overflow-y-auto">
                    {loadingConvos ? (
                        <div className="p-4 space-y-4">
                            <Skeleton className="h-16 w-full rounded-xl bg-zinc-800" />
                            <Skeleton className="h-16 w-full rounded-xl bg-zinc-800" />
                            <Skeleton className="h-16 w-full rounded-xl bg-zinc-800" />
                        </div>
                    ) : conversations.length === 0 ? (
                        <div className="p-8 text-center text-zinc-500 text-sm">No conversations yet.</div>
                    ) : (
                        conversations.map(convo => (
                            <div
                                key={convo.id}
                                onClick={() => setActiveConversationId(convo.id)}
                                className={`p-4 flex items-start gap-3 cursor-pointer hover:bg-zinc-800/40 transition-colors border-b border-zinc-800/50 ${activeConversationId === convo.id ? 'bg-zinc-800/60 border-l-2 border-l-indigo-500' : ''}`}
                            >
                                <div className="relative">
                                    <div className={`w-10 h-10 rounded-full flex items-center justify-center text-xs font-bold text-white bg-indigo-600 overflow-hidden`}>
                                        {convo.participant?.avatar_url ? <img src={convo.participant.avatar_url} className="w-full h-full object-cover" /> : convo.participant?.full_name?.substring(0, 2).toUpperCase() || convo.sender_name?.substring(0, 2).toUpperCase() || "?"}
                                    </div>
                                </div>
                                <div className="flex-1 min-w-0">
                                    <div className="flex items-center justify-between mb-0.5">
                                        <span className="font-medium text-zinc-200 text-sm truncate">{convo.participant?.full_name || convo.sender_name || "Unknown"}</span>
                                        <span className="text-[10px] text-zinc-500">{convo.last_message ? new Date(convo.last_message.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : ''}</span>
                                    </div>
                                    <p className={`text-xs truncate ${activeConversationId === convo.id ? 'text-zinc-300' : 'text-zinc-500'}`}>
                                        {convo.last_message?.text || "No messages yet"}
                                    </p>
                                </div>
                            </div>
                        ))
                    )}
                </div>
            </div>

            {/* Chat Area */}
            <div className="flex-1 flex flex-col bg-[#0c0c0e] relative h-full">
                {activeConversationId ? (
                    <>
                        {/* Header */}
                        <div className="h-16 border-b border-zinc-800 flex items-center justify-between px-6 bg-[#09090b]/50 backdrop-blur-md">
                            {activeConvo && (
                                <div className="flex items-center gap-3">
                                    <div className={`w-9 h-9 rounded-full flex items-center justify-center text-xs font-bold text-white bg-indigo-600 overflow-hidden`}>
                                        {activeConvo.participant?.avatar_url ? <img src={activeConvo.participant.avatar_url} className="w-full h-full object-cover" /> : activeConvo.participant?.full_name?.substring(0, 2).toUpperCase() || activeConvo.sender_name?.substring(0, 2).toUpperCase() || "?"}
                                    </div>
                                    <div>
                                        <h3 className="font-bold text-zinc-200 text-sm">{activeConvo.participant?.full_name || activeConvo.sender_name}</h3>
                                        <p className="text-xs text-zinc-500">Participant</p>
                                    </div>
                                </div>
                            )}
                            <div className="flex items-center gap-2">
                                <button className="p-2 hover:bg-zinc-800 rounded-full text-zinc-500 hover:text-white transition-colors">
                                    <Phone className="w-4 h-4" />
                                </button>
                                <button className="p-2 hover:bg-zinc-800 rounded-full text-zinc-500 hover:text-white transition-colors">
                                    <Video className="w-4 h-4" />
                                </button>
                                <button className="p-2 hover:bg-zinc-800 rounded-full text-zinc-500 hover:text-white transition-colors">
                                    <Info className="w-4 h-4" />
                                </button>
                            </div>
                        </div>

                        {/* Messages */}
                        <div className="flex-1 overflow-y-auto p-6 space-y-4">
                            {error && (
                                <div className="bg-red-500/10 border-l-4 border-red-500 p-4 mb-4 rounded-r">
                                    <p className="text-sm text-red-200">{error}</p>
                                </div>
                            )}
                            {loadingMessages && messages.length === 0 ? (
                                <div className="flex justify-center p-10"><Loader2 className="animate-spin text-zinc-600" /></div>
                            ) : messages.map((msg) => (
                                <div key={msg.id} className={`flex ${msg.sender_id === userId ? 'justify-end' : 'justify-start'} animate-in slide-in-from-bottom-2 fade-in duration-300`}>
                                    <div className={`max-w-[70%] space-y-1 ${msg.sender_id === userId ? 'items-end flex flex-col' : 'items-start'}`}>
                                        <div className={`px-4 py-2.5 rounded-2xl text-sm leading-relaxed shadow-sm ${msg.sender_id === userId
                                            ? 'bg-indigo-600 text-white rounded-br-none'
                                            : 'bg-zinc-800 text-zinc-200 rounded-bl-none'
                                            }`}>
                                            {msg.content}
                                        </div>
                                        <div className="flex items-center gap-1 text-[10px] text-zinc-500 px-1">
                                            <span className="opacity-50">{new Date(msg.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                                        </div>
                                    </div>
                                </div>
                            ))}
                            <div ref={messagesEndRef} />
                        </div>

                        {/* Input */}
                        <div className="p-4 border-t border-zinc-800 bg-[#09090b]">
                            <form onSubmit={handleSend} className="flex items-end gap-2">
                                <button type="button" className="p-3 text-zinc-500 hover:text-white hover:bg-zinc-800 rounded-xl transition-colors">
                                    <Paperclip className="w-5 h-5" />
                                </button>
                                <div className="flex-1 bg-zinc-900 border border-zinc-800 rounded-xl flex items-center px-4 py-2 gap-2 focus-within:border-indigo-500/50 focus-within:ring-1 focus-within:ring-indigo-500/20 transition-all">
                                    <input
                                        value={inputText}
                                        onChange={(e) => setInputText(e.target.value)}
                                        placeholder="Type a message..."
                                        className="flex-1 bg-transparent border-none outline-none text-zinc-200 text-sm h-10 placeholder:text-zinc-600"
                                    />
                                    <button type="button" className="p-1 text-zinc-500 hover:text-white transition-colors">
                                        <Smile className="w-5 h-5" />
                                    </button>
                                </div>
                                <button
                                    type="submit"
                                    disabled={!inputText.trim()}
                                    className="p-3 bg-indigo-600 text-white rounded-xl hover:bg-indigo-500 transition-all shadow-lg shadow-indigo-900/20 disabled:opacity-50 disabled:cursor-not-allowed transform hover:scale-105 active:scale-95"
                                >
                                    <Send className="w-5 h-5" />
                                </button>
                            </form>
                        </div>
                    </>
                ) : (
                    <div className="flex-1 flex flex-col items-center justify-center text-zinc-500">
                        <div className="w-16 h-16 rounded-2xl bg-zinc-900/50 border border-zinc-800 flex items-center justify-center mb-4 animate-bounce">
                            <MoreHorizontal className="w-8 h-8 opacity-30" />
                        </div>
                        <p className="text-sm">Select a chat to start messaging</p>
                    </div>
                )}
            </div>
        </div>
    );
}
