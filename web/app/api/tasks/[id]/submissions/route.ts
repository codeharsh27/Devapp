import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { fetchApi } from "@/lib/apiClient";

// GET /api/tasks/:id/submissions — List candidates for a task (startup only)
export async function GET(
    request: NextRequest,
    { params }: { params: Promise<{ id: string }> }
) {
    const supabase = await createClient();
    const { id: taskId } = await params;

    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;
    if (!token) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    try {
        const submissions: any[] = await fetchApi(`/api/v1/tasks/${taskId}/submissions`, { token });

        // Return exactly what the frontend expects
        return NextResponse.json({ submissions });
    } catch (error: any) {
        console.error(`[GET /api/tasks/${taskId}/submissions]`, error?.message ?? error);
        return NextResponse.json({ error: error.message }, { status: 500 });
    }
}
