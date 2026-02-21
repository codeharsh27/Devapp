
import { createClient } from "@/lib/supabase/client";

export async function createChatService() {
    const supabase = createClient();

    return {
        async getConversations(userId: string) {
            try {
                // Fetch Conversations where user is a participant
                const { data: myConvos, error: convosError } = await supabase
                    .from('conversation_participants')
                    .select('conversation_id')
                    .eq('user_id', userId);

                if (convosError) {
                    console.error("Error fetching conversation participants:", convosError);
                    throw convosError;
                }

                if (!myConvos || myConvos.length === 0) return [];

                const conversationIds = myConvos.map(c => c.conversation_id);

                // Fetch details
                const { data: convos, error } = await supabase
                    .from('conversations')
                    .select(`
                        id, 
                        updated_at,
                        participants:conversation_participants(
                            user:profiles(id, full_name, avatar_url, role)
                        ),
                        messages(content, created_at, sender_id)
                    `)
                    .in('id', conversationIds)
                    .order('updated_at', { ascending: false });

                if (error) {
                    console.error("Error fetching conversations details:", error);
                    throw error;
                }

                return convos.map((c: any) => {
                    const otherParticipant = c.participants.find((p: any) => p.user?.id !== userId)?.user;
                    const target = otherParticipant || c.participants[0]?.user || { full_name: "Unknown User" };

                    // Sorting messages to get last one
                    const sortedMessages = c.messages?.sort((a: any, b: any) =>
                        new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
                    );
                    const lastMsg = sortedMessages?.[0];

                    return {
                        id: c.id,
                        participant: target,
                        last_message: lastMsg ? { text: lastMsg.content, created_at: lastMsg.created_at } : null,
                        updated_at: c.updated_at
                    };
                });
            } catch (error) {
                console.error("getConversations failed:", error);
                throw error;
            }
        },

        async getMessages(conversationId: string) {
            try {
                const { data, error } = await supabase
                    .from('messages')
                    .select('*')
                    .eq('conversation_id', conversationId)
                    .order('created_at', { ascending: true });

                if (error) {
                    console.error("Error fetching messages:", error);
                    throw error;
                }
                return data;
            } catch (error) {
                console.error("getMessages failed:", error);
                throw error;
            }
        },

        async sendMessage(conversationId: string, content: string, senderId: string) {
            try {
                const { error } = await supabase
                    .from('messages')
                    .insert({
                        conversation_id: conversationId,
                        sender_id: senderId,
                        content
                    });

                if (error) {
                    console.error("Error sending message:", error);
                    throw error;
                }

                const { error: updateError } = await supabase
                    .from('conversations')
                    .update({ updated_at: new Date().toISOString() })
                    .eq('id', conversationId);

                if (updateError) {
                    console.error("Error updating conversation timestamp:", updateError);
                }
            } catch (error) {
                console.error("sendMessage failed:", error);
                throw error;
            }
        },

        async startConversation(myId: string, otherId: string) {
            try {
                const { data, error } = await supabase.rpc('create_new_conversation', {
                    other_user_id: otherId
                });

                if (error) {
                    console.error("RPC Error creating conversation:", error);
                    throw error;
                }

                return data;
            } catch (error) {
                console.error("startConversation failed:", error);
                throw error;
            }
        }
    };
}
