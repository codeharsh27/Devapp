import { createClient } from "@/lib/supabase/client";
import { fetchApi } from "@/lib/apiClient";

export async function createChatService() {
    const supabase = createClient();
    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;

    return {
        async getConversations(userId: string) {
            try {
                const convos: any[] = await fetchApi('/api/v1/chat', { token });
                return convos.map(c => ({
                    id: c.id,
                    task_id: null,
                    participant: { full_name: c.sender_name || "Startup", avatar_url: "" },
                    last_message: c.last_message ? { text: c.last_message, created_at: c.last_message_time || c.updated_at } : null,
                    updated_at: c.updated_at,
                    unread_count: c.unread_count || 0
                }));
            } catch (error) {
                console.error("Failed to fetch conversations:", error);
                return [];
            }
        },

        async getMessages(conversationId: string) {
            try {
                const detail: any = await fetchApi(`/api/v1/chat/${conversationId}`, { token });
                return detail.messages?.map((m: any) => ({
                    id: m.id,
                    content: m.content,
                    created_at: m.created_at,
                    sender_id: m.is_from_user ? 'me' : 'them', // Adjust based on frontend expectations
                    conversation_id: conversationId,
                    is_from_user: m.is_from_user
                })) || [];
            } catch (error) {
                console.error("Failed to fetch messages:", error);
                return [];
            }
        },

        async sendMessage(conversationId: string, content: string, senderId: string) {
            await fetchApi(`/api/v1/chat/${conversationId}/messages`, {
                method: 'POST',
                token,
                body: JSON.stringify({
                    content,
                    attachment_url: null,
                    attachment_type: null
                })
            });
        },

        async startConversation(myId: string, otherId: string): Promise<string> {
            // Note: Currently inbox.py requires admin secret to start conversation 
            // from the recruiter/admin side. If this is a talent dashboard trying to start
            // it will fail unless we use the REST API route with internal secret on server side.
            // As a fallback, we invoke the Next.js API route that has the secret server-side.
            const resp = await fetch("/api/conversations", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": `Bearer ${token}`
                },
                body: JSON.stringify({ participant_id: otherId }),
            });

            if (!resp.ok) {
                const body = await resp.json().catch(() => ({}));
                throw new Error(body.error ?? `Failed to start conversation (${resp.status})`);
            }

            const body = await resp.json();
            return body.conversation_id as string;
        },
    };
}
