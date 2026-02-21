
import { useEffect, useState, useRef } from "react";
import { createClient } from "@/lib/supabase/client";
import { createChatService } from "@/lib/services/chat";

export function useChat(userId: string | undefined) {
    const [conversations, setConversations] = useState<any[]>([]);
    const [messages, setMessages] = useState<any[]>([]);
    const [activeConversationId, setActiveConversationId] = useState<string | null>(null);
    const [loadingConvos, setLoadingConvos] = useState(true);
    const [loadingMessages, setLoadingMessages] = useState(false);
    const [error, setError] = useState<string | null>(null);

    // Fetch Conversations
    useEffect(() => {
        if (!userId) return;
        const fetchConvos = async () => {
            try {
                const service = await createChatService();
                const data = await service.getConversations(userId);
                setConversations(data);
                setError(null);
            } catch (e: any) {
                console.error("fetchConvos error:", JSON.stringify(e, null, 2), e);
                setError(e.message || "Failed to load conversations");
            } finally {
                setLoadingConvos(false);
            }
        };
        fetchConvos();
    }, [userId]);

    // Fetch Messages when active changes
    useEffect(() => {
        if (!activeConversationId || !userId) return;

        const fetchMsgs = async () => {
            setLoadingMessages(true);
            try {
                const service = await createChatService();
                const data = await service.getMessages(activeConversationId);
                setMessages(data || []);
                setError(null);
            } catch (e: any) {
                console.error("fetchMsgs error:", JSON.stringify(e, null, 2), e);
                setError(e.message || "Failed to load messages");
            } finally {
                setLoadingMessages(false);
            }
        };
        fetchMsgs();

        // Subscription
        const supabase = createClient();
        const channel = supabase
            .channel(`chat:${activeConversationId}`)
            .on('postgres_changes', {
                event: 'INSERT',
                schema: 'public',
                table: 'messages',
                filter: `conversation_id=eq.${activeConversationId}`
            }, (payload) => {
                const newMsg = payload.new;
                setMessages(prev => [...prev, newMsg]);

                // Update conversation preview
                setConversations(prev => prev.map(c =>
                    c.id === activeConversationId
                        ? { ...c, last_message: { text: newMsg.content, created_at: newMsg.created_at } }
                        : c
                ).sort((a, b) => new Date(b.last_message?.created_at || 0).getTime() - new Date(a.last_message?.created_at || 0).getTime())); // Move to top
            })
            .subscribe((status) => {
                if (status === 'SUBSCRIBED') {
                    // console.log('Subscribed to chat');
                }
            });

        return () => {
            supabase.removeChannel(channel);
        };
    }, [activeConversationId, userId]);

    // Send Message
    const sendMessage = async (content: string) => {
        if (!activeConversationId || !userId) return;
        try {
            const service = await createChatService();
            await service.sendMessage(activeConversationId, content, userId);
            setError(null);
        } catch (e: any) {
            console.error("sendMessage error:", e);
            setError(e.message || "Failed to send message");
        }
    };

    const startChat = async (otherUserId: string) => {
        if (!userId) return;
        try {
            const service = await createChatService();
            const convoId = await service.startConversation(userId, otherUserId);
            setActiveConversationId(convoId);
            // Also refresh convos?
            const data = await service.getConversations(userId);
            setConversations(data);
            setError(null);
        } catch (e: any) {
            console.error("startChat error:", e);
            setError(e.message || "Failed to start chat");
        }
    };

    return {
        conversations,
        messages,
        activeConversationId,
        setActiveConversationId,
        sendMessage,
        startChat,
        loadingConvos,
        loadingMessages,
        error
    };
}
