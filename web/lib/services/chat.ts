import { createClient } from "@/lib/supabase/client";

export async function createChatService() {
    const supabase = createClient();

    return {
        /**
         * Fetch all conversations for a user with the last message preview.
         * Uses a single joined query instead of fetching all messages separately.
         */
        async getConversations(userId: string) {
            const { data: convos, error } = await supabase
                .from("conversations")
                .select(`
                    id,
                    updated_at,
                    task_id,
                    participants:conversation_participants(
                        user:profiles(id, full_name, avatar_url, role, company_name)
                    ),
                    last_message:messages(content, created_at, sender_id)
                `)
                .order("updated_at", { ascending: false });

            if (error) throw error;

            return (convos ?? []).map((c: any) => {
                const otherParticipant = c.participants?.find(
                    (p: any) => p.user?.id !== userId
                )?.user;

                // messages are returned by Supabase in insertion order;
                // pick the most recent by sorting on the client (small array).
                const sortedMessages = [...(c.last_message ?? [])].sort(
                    (a: any, b: any) =>
                        new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
                );
                const lastMsg = sortedMessages[0] ?? null;

                return {
                    id: c.id,
                    task_id: c.task_id,
                    participant: otherParticipant ?? { full_name: "Unknown User" },
                    last_message: lastMsg
                        ? { text: lastMsg.content, created_at: lastMsg.created_at, sender_id: lastMsg.sender_id }
                        : null,
                    updated_at: lastMsg?.created_at ?? c.updated_at,
                };
            });
        },

        /**
         * Fetch all messages in a conversation, oldest first.
         */
        async getMessages(conversationId: string) {
            const { data, error } = await supabase
                .from("messages")
                .select("*")
                .eq("conversation_id", conversationId)
                .order("created_at", { ascending: true });

            if (error) throw error;
            return data ?? [];
        },

        /**
         * Send a message to a conversation and bump the conversation's updated_at.
         */
        async sendMessage(conversationId: string, content: string, senderId: string) {
            const { error } = await supabase.from("messages").insert({
                conversation_id: conversationId,
                sender_id: senderId,
                content,
            });

            if (error) throw error;

            // Bump updated_at so the conversation sorts to the top
            await supabase
                .from("conversations")
                .update({ updated_at: new Date().toISOString() })
                .eq("id", conversationId);
        },

        /**
         * Find or create a conversation between the current user and another user.
         *
         * Uses the Supabase RPC `get_or_create_conversation` (defined in
         * supabase/schema/99_realtime_and_functions.sql) which handles the
         * race-condition safe atomic create-or-return logic.
         *
         * Falls back to the REST API route `/api/conversations` if the RPC
         * is not available (e.g., during local development before migrations run).
         */
        async startConversation(myId: string, otherId: string): Promise<string> {
            // Primary path: Supabase RPC (get_or_create_conversation)
            // Note: RPC name must match exactly what's in your Supabase migrations.
            const { data, error } = await supabase.rpc("get_or_create_conversation", {
                other_user_id: otherId,
            });

            if (!error && data) {
                return data as string;
            }

            // Fallback: REST API route (handles creation manually)
            // This path is hit if the RPC doesn't exist yet or returns an error.
            const resp = await fetch("/api/conversations", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
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
