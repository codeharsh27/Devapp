import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { fetchApi } from "@/lib/apiClient";

// POST /api/tasks/:id/award — Startup finalises task & pays developer
export async function POST(
    request: NextRequest,
    { params }: { params: Promise<{ id: string }> }
) {
    const supabase = await createClient();
    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;

    if (!token) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const { submission_id } = await request.json();
    if (!submission_id) return NextResponse.json({ error: "Missing submission_id" }, { status: 400 });

    try {
        const data: any = await fetchApi(`/api/v1/submissions/${submission_id}/review`, {
            method: 'POST',
            token: token,
            body: JSON.stringify({ action: "ACCEPT", feedback: "Awesome work! We'd like to work with you." })
        });

        // The FastAPI backend handles:
        // - Authorization check (is startup the owner of the task?)
        // - Submission state update to HIRED
        // - Task state update to CLOSED
        // - Developer XP bonus awarding

        return NextResponse.json({
            success: true,
            status: data.status,
            message: data.message
        });

    } catch (err: any) {
        console.error("[POST /api/tasks/[id]/award]", err?.message ?? err);
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
