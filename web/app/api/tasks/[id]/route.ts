import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// GET /api/tasks/:id - Get Single Task Details
export async function GET(
    request: NextRequest,
    { params }: { params: { id: string } }
) {
    const supabase = await createClient();
    const taskId = params.id;

    const { data: task, error } = await supabase
        .from("tasks")
        .select(`
        *,
        criteria:task_criteria(*)
    `)
        .eq("id", taskId)
        .single();

    if (error) return NextResponse.json({ error: "Task not found" }, { status: 404 });

    return NextResponse.json({ task });
}
