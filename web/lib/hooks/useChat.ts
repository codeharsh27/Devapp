
import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { createChatService } from "@/lib/services/chat";
import { useAppDispatch, useAppSelector } from "@/lib/store/hooks";
import { setConversations, setMessages, addMessage, setActiveConversation } from "@/lib/store/slices/chatSlice";

export function useChat(userId: string | undefined) {
    const dispatch = useAppDispatch();
    const chatState = useAppSelector(state => state.chat);

    // We can pull these straight from Redux
    const conversations = chatState.conversations;
    const activeConversationId = chatState.activeConversationId;
    const messages = activeConversationId ? (chatState.messages[activeConversationId] || []) : [];

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
                dispatch(setConversations(data));
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
                dispatch(setMessages({ conversationId: activeConversationId, messages: data || [] }));
                setError(null);
            } catch (e: any) {
                console.error("fetchMsgs error:", JSON.stringify(e, null, 2), e);
                setError(e.message || "Failed to load messages");
            } finally {
                setLoadingMessages(false);
            }
        };
        // Only fetch if Redux doesn't have it yet to optimize
        if (!chatState.messages[activeConversationId]) {
            fetchMsgs();
        }

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
                const newMsg = payload.new as any;
                dispatch(addMessage(newMsg));

                // Update conversation preview implicitly by fetching conversations again?
                // Or we can write a dedicated redux action to bump the conversation order and preview. 
                // For now, easy solution is to refetch conversations
                createChatService().then(s => s.getConversations(userId).then(data => dispatch(setConversations(data))));
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
            dispatch(setActiveConversation(convoId));
            // Also refresh convos?
            const data = await service.getConversations(userId);
            dispatch(setConversations(data));
            setError(null);
        } catch (e: any) {
            console.error("startChat error:", e);
            setError(e.message || "Failed to start chat");
        }
    };

    // Wrapped setter
    const setLocalActiveConversationId = (id: string | null) => {
        dispatch(setActiveConversation(id));
    };

    return {
        conversations,
        messages,
        activeConversationId,
        setActiveConversationId: setLocalActiveConversationId,
        sendMessage,
        startChat,
        loadingConvos,
        loadingMessages,
        error
    };
}
