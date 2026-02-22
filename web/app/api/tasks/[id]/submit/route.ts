import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// POST /api/tasks/:id/submit — Developer submits work
export async function POST(
    request: NextRequest,
    { params }: { params: Promise<{ id: string }> }
) {
    const supabase = await createClient();
    const { id: taskId } = await params;

    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    // Verify role
    const { data: profile } = await supabase
        .from("profiles")
        .select("role, reputation_score")
        .eq("id", user.id)
        .single();

    if (!profile || (profile.role !== "talent" && profile.role !== "Developer")) {
        return NextResponse.json({ error: "Only developers can submit work" }, { status: 403 });
    }

    try {
        const body = await request.json();
        const { repo_url, commit_hash, notes } = body;

        if (!repo_url) {
            return NextResponse.json({ error: "Repository URL is required" }, { status: 400 });
        }

        // Validate task is open
        const { data: task } = await supabase
            .from("tasks")
            .select("status, deadline")
            .eq("id", taskId)
            .single();

        if (!task) return NextResponse.json({ error: "Task not found" }, { status: 404 });
        if (task.status !== "open") return NextResponse.json({ error: "Task is closed for submissions" }, { status: 400 });
        if (task.deadline && new Date(task.deadline) < new Date()) {
            return NextResponse.json({ error: "Deadline has passed" }, { status: 400 });
        }

        // One submission per developer per task
        const { data: existing } = await supabase
            .from("submissions")
            .select("id")
            .eq("task_id", taskId)
            .eq("developer_id", user.id)
            .maybeSingle();

        if (existing) {
            return NextResponse.json({ error: "You have already submitted for this task." }, { status: 409 });
        }

        const { data: submission, error: submitError } = await supabase
            .from("submissions")
            .insert({
                task_id: taskId,
                developer_id: user.id,
                repo_url,
                commit_hash,
                notes,
                status: "pending",
            })
            .select()
            .single();

        if (submitError) throw submitError;

        // TODO (production): queue.add('evaluate-submission', { submissionId: submission.id })

        return NextResponse.json({ success: true, submission });

    } catch (err: any) {
        console.error("[POST /api/tasks/[id]/submit]", err?.message ?? err);
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
