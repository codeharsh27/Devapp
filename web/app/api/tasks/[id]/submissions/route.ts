import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// GET /api/tasks/:id/submissions - List Candidates for a Task
export async function GET(
    request: NextRequest,
    { params }: { params: { id: string } }
) {
    const supabase = await createClient();
    const taskId = params.id;

    // 1. Auth Check (Startup Only)
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
        return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // 2. Verify Task Ownership
    const { data: task } = await supabase
        .from("tasks")
        .select("startup_id")
        .eq("id", taskId)
        .single();

    if (!task) return NextResponse.json({ error: "Task not found" }, { status: 404 });

    // Strict: Only the creator can see submissions? Or any startup admin?
    // ideally check user.id === task.startup_id
    if (task.startup_id !== user.id) {
        // Allow if they are part of the same org (future feature), for now strict.
        // But for testing, relax if needed. Let's keep strict.
        return NextResponse.json({ error: "Unauthorized" }, { status: 403 });
    }

    // 3. Fetch Submissions with Developer Profile
    const { data: submissions, error } = await supabase
        .from("submissions")
        .select(`
        *,
        developer:profiles(id, full_name, avatar_url, username, role, reputation_score)
    `)
        .eq("task_id", taskId)
        .order('final_score', { ascending: false }) // Rank by score
        .order('created_at', { ascending: true });   // Then by time

    if (error) return NextResponse.json({ error: error.message }, { status: 500 });

    return NextResponse.json({ submissions });
}
