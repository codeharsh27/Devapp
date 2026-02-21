import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// POST /api/conversations
// Start or retrieve a conversation with a user
export async function POST(request: NextRequest) {
    const supabase = await createClient();

    // 1. Auth Check
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const { participant_id, task_id } = await request.json();
    if (!participant_id) return NextResponse.json({ error: "Missing participant_id" }, { status: 400 });

    try {
        // 2. Check if conversation already exists between these 2 users
        // Use RPC or double query.
        const { data: myConvos } = await supabase
            .from('conversation_participants')
            .select('conversation_id')
            .eq('user_id', user.id);

        const myConvoIds = myConvos?.map(c => c.conversation_id) || [];

        if (myConvoIds.length > 0) {
            // Find if participant_id is in any of these conversations
            const { data: sharedConvo } = await supabase
                .from('conversation_participants')
                .select('conversation_id')
                .in('conversation_id', myConvoIds)
                .eq('user_id', participant_id)
                .maybeSingle();

            if (sharedConvo) {
                return NextResponse.json({ conversation_id: sharedConvo.conversation_id, is_new: false });
            }
        }

        // 3. Create New Conversation
        const { data: newConvo, error: createError } = await supabase
            .from('conversations')
            .insert({ task_id: task_id || null })
            .select()
            .single();

        if (createError) throw createError;

        // 4. Add Participants
        await supabase.from('conversation_participants').insert([
            { conversation_id: newConvo.id, user_id: user.id },
            { conversation_id: newConvo.id, user_id: participant_id }
        ]);

        return NextResponse.json({ conversation_id: newConvo.id, is_new: true });

    } catch (err: any) {
        console.error("Chat Creation Error:", err);
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}

// GET /api/conversations
// List all conversations for the current user
export async function GET(request: NextRequest) {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    try {
        const { data: participations } = await supabase
            .from('conversation_participants')
            .select('conversation_id')
            .eq('user_id', user.id);

        const convoIds = participations?.map((p: any) => p.conversation_id) || [];
        if (convoIds.length === 0) return NextResponse.json({ conversations: [] });

        // Fetch Metadata
        const { data: convos } = await supabase
            .from('conversations')
            .select('*')
            .in('id', convoIds);

        // Fetch Participants
        const { data: participants } = await supabase
            .from('conversation_participants')
            .select(`conversation_id, user:profiles(id, full_name, role, avatar_url, company_name)`)
            .in('conversation_id', convoIds);

        // Fetch Last Messages (Inefficient but works for MVP)
        // Ideally: RPC call or view
        // We will just fetch ALL messages for these convos and filter in memory (assuming low volume)
        // Or fetch latest 1 via loop? 
        // Let's fetch all messages created in last 30 days? Or just all.
        const { data: messages } = await supabase
            .from('messages')
            .select('*')
            .in('conversation_id', convoIds)
            .order('created_at', { ascending: false });

        const result = convos?.map((c: any) => {
            // Find other participant
            const other = participants?.find((p: any) => p.conversation_id === c.id && p.user?.id !== user.id)?.user;

            // Find latest message for this convo
            // Since messages are sorted by created_at DESC, find first match
            const lastMsg = messages?.find((m: any) => m.conversation_id === c.id);

            // Count unread? (Skip for now)

            return {
                id: c.id,
                participant: other || { full_name: 'Unknown User' },
                last_message: lastMsg ? {
                    text: lastMsg.content,
                    created_at: lastMsg.created_at,
                    sender_id: lastMsg.sender_id
                } : null,
                updated_at: lastMsg?.created_at || c.created_at
            };
        }).sort((a: any, b: any) => new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime());

        return NextResponse.json({ conversations: result });

    } catch (err: any) {
        console.error("Chat List Error:", err);
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
