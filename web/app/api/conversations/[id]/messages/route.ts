import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// POST /api/conversations/:id/messages
// Send a message
export async function POST(
    request: NextRequest,
    { params }: { params: { id: string } }
) {
    const supabase = await createClient();
    const conversationId = params.id;

    // 1. Auth Check
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const { content } = await request.json();
    if (!content) return NextResponse.json({ error: "Missing content" }, { status: 400 });

    try {
        // 2. Validate Membership
        // Ensure user is part of this conversation
        const { data: member } = await supabase
            .from('conversation_participants')
            .select('conversation_id')
            .eq('conversation_id', conversationId)
            .eq('user_id', user.id)
            .single();

        if (!member) return NextResponse.json({ error: "Not a participant" }, { status: 403 });

        // 3. Insert Message
        const { data: newMessage, error } = await supabase
            .from('messages')
            .insert({
                conversation_id: conversationId,
                sender_id: user.id,
                content: content
            })
            .select()
            .single();

        if (error) throw error;

        return NextResponse.json({ success: true, message: newMessage });

    } catch (err: any) {
        console.error("Message Send Error:", err);
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}

// GET /api/conversations/:id/messages
// Get message history
export async function GET(
    request: NextRequest,
    { params }: { params: { id: string } }
) {
    const supabase = await createClient();
    const conversationId = params.id;

    // 1. Auth Check
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    try {
        // 2. Validate Membership
        const { data: member } = await supabase
            .from('conversation_participants')
            .select('conversation_id')
            .eq('conversation_id', conversationId)
            .eq('user_id', user.id)
            .single();

        if (!member) return NextResponse.json({ error: "Not a participant" }, { status: 403 });

        // 3. Fetch Messages
        const { data: messages } = await supabase
            .from('messages')
            .select('*')
            .eq('conversation_id', conversationId)
            .order('created_at', { ascending: true });

        return NextResponse.json({ messages });

    } catch (err: any) {
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
