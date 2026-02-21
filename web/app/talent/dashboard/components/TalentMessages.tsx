"use client";
import { useState, useEffect, useRef } from "react";
import { Send, Search, MoreHorizontal, Paperclip, CheckCheck, Smile, Phone, Video, Info, Loader2 } from "lucide-react";
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

export function TalentMessages({ userId }: { userId: string | undefined }) {
    const supabase = createClient();
    const [conversations, setConversations] = useState<Conversation[]>([]);
    const [selectedConvoId, setSelectedConvoId] = useState<string | null>(null);
    const [messages, setMessages] = useState<Message[]>([]);
    const [loading, setLoading] = useState(true);
    const [loadingMessages, setLoadingMessages] = useState(false);
    const [inputText, setInputText] = useState("");
    const messagesEndRef = useRef<HTMLDivElement>(null);

    // 1. Load Conversations
    useEffect(() => {
        if (!userId) return;
        const loadData = async () => {
            try {
                // Mocking conversation fetch for now since we don't have the endpoint yet
                // In real app: const res = await fetch('/api/conversations');
                setConversations([]);
            } catch (err) {
                console.error("Failed to load chats", err);
            } finally {
                setLoading(false);
            }
        };
        loadData();
    }, [userId]);

    return (
        <div className="flex-1 flex h-full overflow-hidden bg-[#0c0c0e] animate-in fade-in duration-500">
            <div className="flex items-center justify-center w-full h-full text-zinc-500">
                Messages coming soon using Supabase Realtime.
            </div>
        </div>
    );
}
