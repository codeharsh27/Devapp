import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// POST /api/tasks/:id/submit - Developer Submits Code
export async function POST(
    request: NextRequest,
    { params }: { params: { id: string } }
) {
    const supabase = await createClient();
    const taskId = params.id;

    // 1. Auth Check (Talent Only)
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
        return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // 2. Fetch User Role & Reputation
    const { data: profile } = await supabase
        .from("profiles")
        .select("role, reputation_score")
        .eq("id", user.id)
        .single();

    // Basic check: is role 'talent'?
    if (!profile || profile.role !== 'talent' && profile.role !== 'Developer') {
        return NextResponse.json({ error: "Only developers can submit work" }, { status: 403 });
    }

    try {
        const body = await request.json();
        const { repo_url, commit_hash, notes } = body;

        if (!repo_url) {
            return NextResponse.json({ error: "Repository URL is required" }, { status: 400 });
        }

        // 3. Task Validation (Is it open?)
        const { data: task } = await supabase
            .from("tasks")
            .select("status, deadline")
            .eq("id", taskId)
            .single();

        if (!task) return NextResponse.json({ error: "Task not found" }, { status: 404 });
        if (task.status !== 'open') return NextResponse.json({ error: "Task is closed for submissions" }, { status: 400 });

        if (task.deadline && new Date(task.deadline) < new Date()) {
            return NextResponse.json({ error: "Deadline has passed" }, { status: 400 });
        }

        // 4. Duplicate Submission Check (Optional: Allow re-submission?)
        // For now, allow re-submission but mark previous as stale or replace?
        // Let's assume one active submission per task for MVP.
        const { data: existing } = await supabase
            .from("submissions")
            .select("id")
            .eq("task_id", taskId)
            .eq("developer_id", user.id)
            .maybeSingle();

        if (existing) {
            return NextResponse.json({ error: "You have already submitted for this task." }, { status: 409 });
        }

        // 5. Create Submission Record
        const { data: submission, error: submitError } = await supabase
            .from("submissions")
            .insert({
                task_id: taskId,
                developer_id: user.id,
                repo_url,
                commit_hash,
                notes,
                status: 'pending' // Ready for evaluation worker
            })
            .select()
            .single();

        if (submitError) throw submitError;

        // 6. Trigger Evaluation
        // TODO (production): Replace with a proper job queue call:
        // await queue.add('evaluate-submission', { submissionId: submission.id });
        // For now, evaluation is triggered separately by an admin or cron job.

        return NextResponse.json({ success: true, submission });

    } catch (err: any) {
        console.error("Submit Error:", err);
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
