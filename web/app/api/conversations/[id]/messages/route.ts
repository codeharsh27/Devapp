import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// POST /api/conversations/:id/messages — Send a message
export async function POST(
    request: NextRequest,
    { params }: { params: Promise<{ id: string }> }
) {
    const supabase = await createClient();
    const { id: conversationId } = await params;

    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const { content } = await request.json();
    if (!content) return NextResponse.json({ error: "Missing content" }, { status: 400 });

    try {
        // Validate membership — user must be a participant
        const { data: member } = await supabase
            .from("conversation_participants")
            .select("conversation_id")
            .eq("conversation_id", conversationId)
            .eq("user_id", user.id)
            .single();

        if (!member) return NextResponse.json({ error: "Not a participant" }, { status: 403 });

        const { data: newMessage, error } = await supabase
            .from("messages")
            .insert({
                conversation_id: conversationId,
                sender_id: user.id,
                content,
            })
            .select()
            .single();

        if (error) throw error;

        // Bump conversation updated_at for sorting
        await supabase
            .from("conversations")
            .update({ updated_at: new Date().toISOString() })
            .eq("id", conversationId);

        return NextResponse.json({ success: true, message: newMessage });

    } catch (err: any) {
        console.error("[POST /api/conversations/[id]/messages]", err?.message ?? err);
        return NextResponse.json({ error: "Failed to send message" }, { status: 500 });
    }
}

// GET /api/conversations/:id/messages — Fetch message history
export async function GET(
    request: NextRequest,
    { params }: { params: Promise<{ id: string }> }
) {
    const supabase = await createClient();
    const { id: conversationId } = await params;

    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    try {
        // Validate membership
        const { data: member } = await supabase
            .from("conversation_participants")
            .select("conversation_id")
            .eq("conversation_id", conversationId)
            .eq("user_id", user.id)
            .single();

        if (!member) return NextResponse.json({ error: "Not a participant" }, { status: 403 });

        const { data: messages, error } = await supabase
            .from("messages")
            .select("*")
            .eq("conversation_id", conversationId)
            .order("created_at", { ascending: true });

        if (error) throw error;

        return NextResponse.json({ messages });

    } catch (err: any) {
        console.error("[GET /api/conversations/[id]/messages]", err?.message ?? err);
        return NextResponse.json({ error: "Failed to fetch messages" }, { status: 500 });
    }
}
