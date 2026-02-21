"use client";
import { useState, useRef, useEffect } from "react";
import { Send, Search, MoreHorizontal, User, Paperclip, Phone, Video, Info, ArrowLeft, Image as ImageIcon, Smile, Mic, MessageSquare, CheckCheck, Bell, Loader2 } from "lucide-react";
import { Space_Grotesk } from "next/font/google";
import { createClient } from "@/lib/supabase/client";

const spaceGrotesk = Space_Grotesk({
    subsets: ["latin"],
    weight: ["300", "400", "500", "600"],
});

interface Message {
    id: string;
    sender_id: string;
    content: string;
    created_at: string;
}

interface Conversation {
    id: string;
    participant: {
        id: string;
        full_name: string;
        role: string;
        avatar_url: string;
        company_name?: string;
    };
    last_message: {
        text: string;
        created_at: string;
    } | null;
    updated_at: string;
}

export function MessagesView({ preSelectedUser }: { preSelectedUser?: { name: string, role: string, dropId?: string, isInvite?: boolean } | null }) {
    const supabase = createClient();
    const [conversations, setConversations] = useState<Conversation[]>([]);
    const [selectedConvoId, setSelectedConvoId] = useState<string | null>(null);
    const [messages, setMessages] = useState<Message[]>([]);
    const [messageInput, setMessageInput] = useState("");
    const [loading, setLoading] = useState(true);
    const [loadingMessages, setLoadingMessages] = useState(false);
    const [userId, setUserId] = useState<string | null>(null);
    const [showContextPanel, setShowContextPanel] = useState(true);
    const messagesEndRef = useRef<HTMLDivElement>(null);

    // 1. Initial Load
    useEffect(() => {
        const loadData = async () => {
            const { data: { user } } = await supabase.auth.getUser();
            if (user) setUserId(user.id);

            try {
                const res = await fetch('/api/conversations');
                const data = await res.json();
                if (data.conversations) {
                    setConversations(data.conversations);
                }
            } catch (err) {
                console.error("Failed to load chats", err);
            } finally {
                setLoading(false);
            }
        };
        loadData();
    }, []);

    // 2. Handle Pre-selection (e.g. from DropDetail)
    useEffect(() => {
        const handlePreSelection = async () => {
            if (preSelectedUser && !selectedConvoId) {
                // If we have a name, we need to find the user ID properly.
                // But DropDetail passed 'name' only? 
                // Wait, DropDetail passed `sub.developer.full_name` to onMessage.
                // AND it called API to create conversation.
                // Ideally, DropDetail should pass the `conversationId` directly or `userId`.
                // The current flow in DropDetailView.tsx is:
                // 1. Click Message -> Call API -> Alert ID -> (TODO: Redirect)
                // If we are passing props via parent `DashboardPage`, we need to update `DashboardPage` to pass `conversationId` or `userId`.

                // For now, let's assume we might find it by name in existing conversations (weak match).
                // Or simply rely on the user refreshing or the API having created it.
                // If DropDetail is updated to pass `userId` to `onMessage`, we can query API here.

                // Given constraints, I'll rely on the conversations list being refreshed.
                // If the conversation exists, we select it.

                const match = conversations.find(c => c.participant.full_name === preSelectedUser.name);
                if (match) setSelectedConvoId(match.id);
            }
        };
        handlePreSelection();
    }, [preSelectedUser, conversations]);

    // 3. Load Messages & Realtime
    useEffect(() => {
        if (!selectedConvoId) return;

        const fetchMessages = async () => {
            setLoadingMessages(true);
            try {
                const res = await fetch(`/api/conversations/${selectedConvoId}/messages`);
                const data = await res.json();
                if (data.messages) {
                    setMessages(data.messages);
                }
            } catch (err) {
                console.error("Failed to load messages", err);
            } finally {
                setLoadingMessages(false);
                scrollToBottom();
            }
        };
        fetchMessages();

        const channel = supabase
            .channel(`chat:${selectedConvoId}`)
            .on(
                'postgres_changes',
                {
                    event: 'INSERT',
                    schema: 'public',
                    table: 'messages',
                    filter: `conversation_id=eq.${selectedConvoId}`
                },
                (payload) => {
                    const newMsg = payload.new as Message;
                    if (newMsg) {
                        setMessages((prev) => [...prev, newMsg]);
                        scrollToBottom();
                        setConversations(prev => prev.map(c =>
                            c.id === selectedConvoId
                                ? { ...c, last_message: { text: newMsg.content, created_at: newMsg.created_at } }
                                : c
                        ));
                    }
                }
            )
            .subscribe();

        return () => {
            supabase.removeChannel(channel);
        };
    }, [selectedConvoId]);

    const scrollToBottom = () => {
        setTimeout(() => {
            messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
        }, 100);
    };

    const handleSendMessage = async (e?: React.FormEvent) => {
        e?.preventDefault();
        if (!messageInput.trim() || !selectedConvoId || !userId) return;

        const content = messageInput;
        const optimisticMsg: Message = {
            id: Date.now().toString(),
            sender_id: userId,
            content: content,
            created_at: new Date().toISOString()
        };

        setMessages(prev => [...prev, optimisticMsg]);
        setMessageInput("");
        scrollToBottom();

        try {
            await fetch(`/api/conversations/${selectedConvoId}/messages`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ content })
            });
        } catch (err) {
            console.error("Send failed", err);
        }
    };

    const activeConvo = conversations.find((c) => c.id === selectedConvoId);

    return (
        <div className="h-full flex overflow-hidden">

            {/* Sidebar List */}
            <div className={`w-full md:w-80 lg:w-[380px] border-r border-zinc-800/50 flex flex-col bg-[#050505] transform transition-all duration-300 ${selectedConvoId ? 'hidden md:flex' : 'flex'}`}>

                {/* Sidebar Header */}
                <div className="p-6">
                    <div className="flex items-center justify-between mb-6">
                        <h2 className={`text-2xl font-medium text-white tracking-tight ${spaceGrotesk.className}`}>Messages</h2>
                        <div className="flex gap-2">
                            <button className="w-8 h-8 flex items-center justify-center hover:bg-zinc-800 rounded-full transition-colors text-zinc-400 hover:text-white">
                                <MoreHorizontal className="w-5 h-5" />
                            </button>
                        </div>
                    </div>
                </div>

                {/* Contact List */}
                <div className="flex-1 overflow-y-auto custom-scrollbar px-3 pb-4 space-y-1">
                    {loading ? (
                        <div className="flex justify-center p-10"><Loader2 className="animate-spin text-zinc-600" /></div>
                    ) : conversations.length === 0 ? (
                        <div className="p-8 text-center text-zinc-500 text-sm">No conversations yet.</div>
                    ) : (
                        conversations.map(convo => (
                            <div
                                key={convo.id}
                                onClick={() => setSelectedConvoId(convo.id)}
                                className={`group flex items-center gap-4 p-4 rounded-2xl cursor-pointer transition-all duration-200
                                    ${selectedConvoId === convo.id
                                        ? 'bg-zinc-900 border-zinc-800 shadow-xl shadow-black/20'
                                        : 'hover:bg-zinc-900/50 hover:pl-5 border border-transparent'}`}
                            >
                                <div className="relative shrink-0">
                                    <div className={`w-12 h-12 rounded-full flex items-center justify-center text-sm font-bold text-white shadow-inner ring-2 ring-zinc-950 bg-gradient-to-br from-indigo-500 to-blue-600 overflow-hidden`}>
                                        {convo.participant.avatar_url ? <img src={convo.participant.avatar_url} className="w-full h-full object-cover" /> : convo.participant.full_name?.substring(0, 2).toUpperCase()}
                                    </div>
                                </div>

                                <div className="flex-1 min-w-0">
                                    <div className="flex items-center justify-between mb-1">
                                        <span className={`font-semibold truncate tracking-tight ${selectedConvoId === convo.id ? 'text-white' : 'text-zinc-300 group-hover:text-white'}`}>
                                            {convo.participant.full_name || "Unknown"}
                                        </span>
                                        <span className="text-[10px] text-zinc-500 font-mono">
                                            {convo.last_message ? new Date(convo.last_message.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : ''}
                                        </span>
                                    </div>
                                    <p className={`text-xs truncate font-medium text-zinc-500 group-hover:text-zinc-400`}>
                                        {convo.last_message?.text || "No messages yet"}
                                    </p>
                                </div>
                            </div>
                        ))
                    )}
                </div>
            </div>

            {/* Main Chat Area */}
            <div className={`flex-1 flex flex-col bg-[#0a0a0a] relative ${!selectedConvoId ? 'hidden md:flex' : 'flex'}`}>

                {!activeConvo ? (
                    <div className="flex-1 flex flex-col items-center justify-center text-zinc-500 space-y-6">
                        <div className="w-24 h-24 rounded-full bg-zinc-900/30 flex items-center justify-center animate-pulse">
                            <MessageSquare className="w-10 h-10 opacity-30" />
                        </div>
                        <div className="text-center">
                            <h3 className="text-lg font-medium text-zinc-300 mb-1">Welcome Back</h3>
                            <p className="text-sm text-zinc-600">Select a chat to start collaborating</p>
                        </div>
                    </div>
                ) : (
                    <>
                        {/* Chat Header */}
                        <div className="h-20 border-b border-zinc-800/50 flex items-center justify-between px-6 md:px-8 bg-[#0a0a0a]/95 backdrop-blur-xl z-10 sticky top-0">
                            <div className="flex items-center gap-4">
                                <button
                                    onClick={() => setSelectedConvoId(null)}
                                    className="md:hidden p-2 hover:bg-zinc-800 rounded-full -ml-2 text-zinc-400"
                                >
                                    <ArrowLeft className="w-5 h-5" />
                                </button>

                                <div className="flex items-center gap-4">
                                    <div className="relative">
                                        <div className={`w-10 h-10 rounded-full flex items-center justify-center text-xs font-bold text-white bg-gradient-to-br from-indigo-500 to-blue-600 overflow-hidden`}>
                                            {activeConvo.participant.avatar_url ? <img src={activeConvo.participant.avatar_url} className="w-full h-full object-cover" /> : activeConvo.participant.full_name?.substring(0, 2).toUpperCase()}
                                        </div>
                                    </div>

                                    <div>
                                        <h3 className="font-bold text-zinc-100 text-sm flex items-center gap-2">
                                            {activeConvo.participant.full_name}
                                        </h3>
                                        <p className="text-xs text-zinc-500 flex items-center gap-1.5 font-medium">
                                            {activeConvo.participant.role}
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div className="flex items-center gap-1">
                                <button
                                    onClick={() => setShowContextPanel(!showContextPanel)}
                                    className={`p-3 rounded-xl transition-colors ${showContextPanel ? 'bg-indigo-500/10 text-indigo-400' : 'hover:bg-zinc-900 text-zinc-400 hover:text-white'}`}
                                >
                                    <Info className="w-5 h-5" />
                                </button>
                            </div>
                        </div>

                        <div className="flex flex-1 overflow-hidden">
                            {/* Messages Feed */}
                            <div className="flex-1 overflow-y-auto p-4 md:p-8 space-y-2">
                                {loadingMessages ? (
                                    <div className="flex justify-center p-10"><Loader2 className="animate-spin text-zinc-600" /></div>
                                ) : (
                                    messages.map((msg) => {
                                        const isMe = msg.sender_id === userId;
                                        return (
                                            <div key={msg.id} className={`flex ${isMe ? 'justify-end' : 'justify-start'} group mb-1`}>
                                                <div className={`flex flex-col max-w-[85%] md:max-w-[70%] ${isMe ? 'items-end' : 'items-start'}`}>
                                                    <div className={`
                                                        px-5 py-3 text-sm leading-relaxed shadow-sm relative transition-all duration-200
                                                        ${isMe
                                                            ? 'bg-[#4f46e5] text-white rounded-[20px] rounded-br-[4px] hover:bg-[#4338ca]'
                                                            : 'bg-zinc-900 text-zinc-200 rounded-[20px] rounded-bl-[4px] hover:bg-zinc-800'}
                                                    `}>
                                                        {msg.content}
                                                    </div>
                                                    <span className="text-[10px] text-zinc-600 mt-1 opacity-0 group-hover:opacity-100 transition-opacity px-1">
                                                        {new Date(msg.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                                    </span>
                                                </div>
                                            </div>
                                        );
                                    })
                                )}
                                <div ref={messagesEndRef} />
                            </div>

                            {/* Right Context Panel (Collapsible) */}
                            {showContextPanel && (
                                <div className="hidden lg:flex w-80 border-l border-zinc-800/50 bg-[#0c0c0e] flex-col p-6 overflow-y-auto animate-in slide-in-from-right duration-300">
                                    <div className="text-center mb-8">
                                        <div className={`w-20 h-20 rounded-full mx-auto flex items-center justify-center text-2xl font-bold text-white mb-4 shadow-2xl bg-gradient-to-br from-indigo-500 to-blue-600 overflow-hidden`}>
                                            {activeConvo.participant.avatar_url ? <img src={activeConvo.participant.avatar_url} className="w-full h-full object-cover" /> : activeConvo.participant.full_name?.substring(0, 2).toUpperCase()}
                                        </div>
                                        <h3 className="text-xl font-bold text-white mb-1">{activeConvo.participant.full_name}</h3>
                                        <p className="text-sm text-zinc-500">{activeConvo.participant.role}</p>
                                    </div>
                                    <div className="text-center text-sm text-zinc-600">User Context & History</div>
                                </div>
                            )}
                        </div>

                        {/* Input Area */}
                        <div className="p-4 md:p-6 bg-[#0a0a0a] border-t border-zinc-800/50 z-20">
                            <form
                                onSubmit={handleSendMessage}
                                className="relative flex items-end gap-2 p-1.5 bg-zinc-900 rounded-3xl border border-zinc-800 shadow-xl focus-within:ring-2 focus-within:ring-indigo-500/20 focus-within:border-indigo-500/50 transition-all"
                            >
                                <div className="flex-1 py-1">
                                    <input
                                        value={messageInput}
                                        onChange={(e) => setMessageInput(e.target.value)}
                                        placeholder="Type a message..."
                                        className="w-full bg-transparent border-none outline-none text-zinc-100 text-base h-10 placeholder:text-zinc-600 px-2"
                                    />
                                </div>
                                <button
                                    type="submit"
                                    disabled={!messageInput.trim()}
                                    className="p-3 bg-indigo-600 text-white rounded-full hover:bg-indigo-500 transition-all shadow-lg shadow-indigo-500/20 active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed disabled:shadow-none ml-1 flex items-center justify-center w-12 h-12"
                                >
                                    <Send className="w-5 h-5 ml-0.5" />
                                </button>
                            </form>
                        </div>
                    </>
                )}
            </div>
        </div>
    );
}
