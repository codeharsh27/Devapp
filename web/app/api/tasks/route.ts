
import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createServerTasksService } from "@/lib/services/server-tasks";
import { rateLimit } from "@/lib/rate-limit";

const limiter = rateLimit({ interval: 60000, uniqueTokenPerInterval: 500 }); // 60s

// POST /api/tasks - Create a new Task (Startup Only)
export async function POST(request: NextRequest) {
    const supabase = await createClient();

    // Rate Limit Check (IP based) - simplified for MVP
    // const ip = request.ip || '127.0.0.1';
    // await limiter.check(10, ip); 

    // 1. Auth Check
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
        return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    try {
        const tasksService = await createServerTasksService();
        const body = await request.json();
        const { title, description, repo_template_url, category, difficulty_level, deadline, max_submissions, criteria } = body;

        // Validation moved to Service or redundant here? 
        // Service handles role check.

        // 2. Call Service to Create Task
        const task = await tasksService.createTask(user.id, {
            title, description, repo_template_url, category, difficulty_level, deadline, max_submissions
        });

        // 3. Insert Criteria (Transaction handling ideal, but sticking to logic)
        // If Logic for criteria is complex, move to service. 
        // For now, we keep it here but strictly checked.
        if (criteria && Array.isArray(criteria) && criteria.length > 0) {
            const criteriaToInsert = criteria.map((c: any) => ({
                task_id: task.id,
                type: c.type,
                weight: c.weight,
                description: c.description,
                test_file_path: c.test_file_path
            }));

            const { error: criteriaError } = await supabase
                .from("task_criteria")
                .insert(criteriaToInsert);

            if (criteriaError) {
                console.error("Error creating criteria:", criteriaError);
                // Note: Task exists but criteria failed. 
            }
        }

        return NextResponse.json({ success: true, task });

    } catch (err: any) {
        console.error("Create Task Error:", err);
        const status = err.message === 'Unauthorized' ? 403 : 500;
        return NextResponse.json({ error: err.message }, { status });
    }
}

// GET /api/tasks - List Tasks (Public/Filtered)
export async function GET(request: NextRequest) {
    // Rate limit
    // await limiter.check(20, request.ip || '127.0.0.1');

    const tasksService = await createServerTasksService();
    const { searchParams } = new URL(request.url);

    const category = searchParams.get('category') || undefined;
    const limit = parseInt(searchParams.get('limit') || '20');

    try {
        const tasks = await tasksService.getOpenTasks({ category, limit });
        return NextResponse.json({ tasks });
    } catch (err: any) {
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
