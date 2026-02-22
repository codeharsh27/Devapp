
import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createServerTasksService } from "@/lib/services/server-tasks";
import { rateLimit } from "@/lib/rate-limit";

// NOTE: This in-memory limiter works correctly for a single-instance deployment.
// For multi-instance/serverless (Vercel, etc.) replace with a Redis-backed
// solution (e.g. @upstash/ratelimit) so limits are shared across all instances.
const postLimiter = rateLimit({ interval: 60000, uniqueTokenPerInterval: 500 });
const getLimiter = rateLimit({ interval: 60000, uniqueTokenPerInterval: 500 });

// Helper: extract client IP from Next.js request headers
function getClientIp(request: NextRequest): string {
    return (
        request.headers.get("x-forwarded-for")?.split(",")[0]?.trim() ||
        request.headers.get("x-real-ip") ||
        "127.0.0.1"
    );
}

// POST /api/tasks - Create a new Task (Startup Only)
export async function POST(request: NextRequest) {
    const supabase = await createClient();

    // Rate Limit: 10 task-creation requests per minute per IP
    const ip = getClientIp(request);
    try {
        await postLimiter.check(10, ip);
    } catch {
        return NextResponse.json(
            { error: "Rate limit exceeded. Please try again later." },
            { status: 429 }
        );
    }

    // 1. Auth Check
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
        return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    try {
        const tasksService = await createServerTasksService();
        const body = await request.json();
        const {
            title, description, repo_template_url,
            category, difficulty_level, deadline, max_submissions, criteria
        } = body;

        // 2. Call Service to Create Task (service handles role check)
        const task = await tasksService.createTask(user.id, {
            title, description, repo_template_url, category, difficulty_level, deadline, max_submissions
        });

        // 3. Insert Criteria if provided
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
                // Task exists but criteria failed — log and continue.
                // Consider wrapping in a DB transaction for atomicity.
            }
        }

        return NextResponse.json({ success: true, task });

    } catch (err: any) {
        console.error("Create Task Error:", err);
        const status = err.message === "Unauthorized" ? 403 : 500;
        return NextResponse.json({ error: err.message }, { status });
    }
}

// GET /api/tasks - List Tasks (Public/Filtered)
export async function GET(request: NextRequest) {
    // Rate Limit: 20 reads per minute per IP
    const ip = getClientIp(request);
    try {
        await getLimiter.check(20, ip);
    } catch {
        return NextResponse.json(
            { error: "Rate limit exceeded. Please try again later." },
            { status: 429 }
        );
    }

    const tasksService = await createServerTasksService();
    const { searchParams } = new URL(request.url);

    const category = searchParams.get("category") || undefined;
    const limit = parseInt(searchParams.get("limit") || "20");

    try {
        const tasks = await tasksService.getOpenTasks({ category, limit });
        return NextResponse.json({ tasks });
    } catch (err: any) {
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
