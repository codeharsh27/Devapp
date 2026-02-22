import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// GET /api/tasks/:id/submissions — List candidates for a task (startup only)
export async function GET(
    request: NextRequest,
    { params }: { params: Promise<{ id: string }> }
) {
    const supabase = await createClient();
    const { id: taskId } = await params;

    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    // Verify task ownership
    const { data: task } = await supabase
        .from("tasks")
        .select("startup_id")
        .eq("id", taskId)
        .single();

    if (!task) return NextResponse.json({ error: "Task not found" }, { status: 404 });

    if (task.startup_id !== user.id) {
        return NextResponse.json({ error: "Unauthorized" }, { status: 403 });
    }

    const { data: submissions, error } = await supabase
        .from("submissions")
        .select(`
            *,
            developer:profiles(id, full_name, avatar_url, username, role, reputation_score)
        `)
        .eq("task_id", taskId)
        .order("final_score", { ascending: false })
        .order("created_at", { ascending: true });

    if (error) return NextResponse.json({ error: error.message }, { status: 500 });

    return NextResponse.json({ submissions });
}
