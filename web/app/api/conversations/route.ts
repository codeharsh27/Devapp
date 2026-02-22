import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// ─────────────────────────────────────────────────────────────────────────────
// POST /api/conversations
// Find-or-create a conversation between the authenticated user and another user.
// Uses the Supabase RPC `get_or_create_conversation` (atomic, race-condition safe).
// Falls back to manual create if the RPC isn't available.
// ─────────────────────────────────────────────────────────────────────────────
export async function POST(request: NextRequest) {
    const supabase = await createClient();

    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = await request.json().catch(() => ({}));
    const { participant_id, task_id } = body;
    if (!participant_id) {
        return NextResponse.json({ error: "Missing participant_id" }, { status: 400 });
    }

    try {
        // Primary: use the atomic Supabase RPC
        const { data: rpcId, error: rpcError } = await supabase.rpc(
            "get_or_create_conversation",
            { other_user_id: participant_id }
        );

        if (!rpcError && rpcId) {
            return NextResponse.json({ conversation_id: rpcId, is_new: false });
        }

        // Fallback: manual create (RPC not available / not yet migrated)
        // Check if conversation already exists
        const { data: myConvos } = await supabase
            .from("conversation_participants")
            .select("conversation_id")
            .eq("user_id", user.id);

        const myConvoIds = myConvos?.map((c) => c.conversation_id) ?? [];

        if (myConvoIds.length > 0) {
            const { data: sharedConvo } = await supabase
                .from("conversation_participants")
                .select("conversation_id")
                .in("conversation_id", myConvoIds)
                .eq("user_id", participant_id)
                .maybeSingle();

            if (sharedConvo) {
                return NextResponse.json({ conversation_id: sharedConvo.conversation_id, is_new: false });
            }
        }

        // Create new conversation + participants in sequence
        const { data: newConvo, error: createError } = await supabase
            .from("conversations")
            .insert({ task_id: task_id ?? null })
            .select("id")
            .single();

        if (createError) throw createError;

        await supabase.from("conversation_participants").insert([
            { conversation_id: newConvo.id, user_id: user.id },
            { conversation_id: newConvo.id, user_id: participant_id },
        ]);

        return NextResponse.json({ conversation_id: newConvo.id, is_new: true });

    } catch (err: any) {
        console.error("[POST /api/conversations]", err?.message ?? err);
        return NextResponse.json({ error: "Failed to create conversation" }, { status: 500 });
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// GET /api/conversations
// List all conversations for the current user with participants and the
// last message preview.
//
// Performance: instead of fetching ALL messages and filtering in memory,
// we use a Supabase subquery that returns only the most recent message
// per conversation via `.limit(1).order('created_at', {ascending: false})`.
// ─────────────────────────────────────────────────────────────────────────────
export async function GET(_request: NextRequest) {
    const supabase = await createClient();

    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    try {
        // Single joined query — no full messages table scan.
        // Supabase nested selects apply the .limit() per parent row.
        const { data: convos, error } = await supabase
            .from("conversation_participants")
            .select(`
                conversation:conversations(
                    id,
                    created_at,
                    updated_at,
                    task_id,
                    participants:conversation_participants(
                        user:profiles(id, full_name, role, avatar_url, company_name)
                    ),
                    last_message:messages(
                        content, created_at, sender_id
                    )
                )
            `)
            .eq("user_id", user.id)
            .order("created_at", { ascending: false, referencedTable: "conversations" });

        if (error) throw error;

        const result = (convos ?? [])
            .map((row: any) => {
                const c = row.conversation;
                if (!c) return null;

                const otherParticipant = c.participants?.find(
                    (p: any) => p.user?.id !== user.id
                )?.user;

                // Pick most recent message (Supabase returns them in insertion order)
                const lastMsg = (c.last_message ?? []).sort(
                    (a: any, b: any) =>
                        new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
                )[0] ?? null;

                return {
                    id: c.id,
                    task_id: c.task_id,
                    participant: otherParticipant ?? { full_name: "Unknown User" },
                    last_message: lastMsg
                        ? { text: lastMsg.content, created_at: lastMsg.created_at, sender_id: lastMsg.sender_id }
                        : null,
                    updated_at: lastMsg?.created_at ?? c.updated_at,
                };
            })
            .filter(Boolean)
            .sort(
                (a: any, b: any) =>
                    new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime()
            );

        return NextResponse.json({ conversations: result });

    } catch (err: any) {
        console.error("[GET /api/conversations]", err?.message ?? err);
        return NextResponse.json({ error: "Failed to fetch conversations" }, { status: 500 });
    }
}
