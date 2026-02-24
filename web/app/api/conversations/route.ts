import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { fetchApi, BACKEND_URL } from "@/lib/apiClient";

export async function POST(request: NextRequest) {
    const supabase = await createClient();

    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;
    if (!token) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const body = await request.json().catch(() => ({}));
    const { participant_id } = body;
    if (!participant_id) {
        return NextResponse.json({ error: "Missing participant_id" }, { status: 400 });
    }

    try {
        // Startup/Admin starting a conversation with a Talent
        const profileResponse = await fetch(`${BACKEND_URL}/users/me`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        const profile = await profileResponse.json();

        // Admin call to FastAPI
        const response: any = await fetch(`${BACKEND_URL}/api/v1/chat/admin/conversations`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`,
                'x-internal-secret': process.env.INTERNAL_API_SECRET || ""
            },
            body: JSON.stringify({
                user_id: participant_id,
                sender_name: profile?.full_name || "Startup",
                sender_role: "Recruiter",
                sender_email: profile?.email,
                message_type: "general",
                subject: "New Mission Connection",
                initial_message: "Hello, I would like to discuss a potential mission with you."
            })
        });

        if (!response.ok) {
            const err = await response.json().catch(() => ({}));
            throw new Error(err.detail || 'Failed to create conversation');
        }

        const data = await response.json();
        return NextResponse.json({ conversation_id: data.id, is_new: true });

    } catch (err: any) {
        console.error("[POST /api/conversations]", err?.message ?? err);
        return NextResponse.json({ error: "Failed to create conversation" }, { status: 500 });
    }
}

export async function GET(_request: NextRequest) {
    const supabase = await createClient();
    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;
    if (!token) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    try {
        const convos: any[] = await fetchApi('/api/v1/chat', { token });

        const result = convos.map(c => ({
            id: c.id,
            task_id: null,
            participant: { full_name: c.sender_name || "Startup", avatar_url: "" },
            last_message: c.last_message ? { text: c.last_message, created_at: c.last_message_time || c.updated_at } : null,
            updated_at: c.updated_at,
            unread_count: c.unread_count || 0
        })).sort((a, b) => new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime());

        return NextResponse.json({ conversations: result });

    } catch (err: any) {
        console.error("[GET /api/conversations]", err?.message ?? err);
        return NextResponse.json({ error: "Failed to fetch conversations" }, { status: 500 });
    }
}
