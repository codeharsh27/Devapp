import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { fetchApi } from "@/lib/apiClient";

// POST /api/tasks/:id/submit — Developer submits work
export async function POST(
    request: NextRequest,
    { params }: { params: Promise<{ id: string }> }
) {
    const supabase = await createClient();
    const { id: taskId } = await params;

    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;
    if (!token) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    try {
        const body = await request.json();
        const { repo_url, commit_hash, notes } = body;

        if (!repo_url) {
            return NextResponse.json({ error: "Repository URL is required" }, { status: 400 });
        }

        const submission = await fetchApi(`/api/v1/tasks/${taskId}/submit`, {
            method: 'POST',
            token,
            body: JSON.stringify({
                repo_url,
                demo_url: commit_hash || null,
                notes: notes || null
            })
        });

        // The FastAPI backend queues the background evaluation automatically
        return NextResponse.json({ success: true, submission });

    } catch (err: any) {
        console.error("[POST /api/tasks/[id]/submit]", err?.message ?? err);
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
