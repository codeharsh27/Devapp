import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// GET /api/tasks/:id — Get single task details
export async function GET(
    request: NextRequest,
    { params }: { params: Promise<{ id: string }> }
) {
    const supabase = await createClient();
    const { id: taskId } = await params;

    const { data: task, error } = await supabase
        .from("tasks")
        .select(`*, criteria:task_criteria(*)`)
        .eq("id", taskId)
        .single();

    if (error) return NextResponse.json({ error: "Task not found" }, { status: 404 });

    return NextResponse.json({ task });
}
