import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// POST /api/tasks/:id/award — Startup finalises task & pays developer
export async function POST(
    request: NextRequest,
    { params }: { params: Promise<{ id: string }> }
) {
    const supabase = await createClient();
    const { id: taskId } = await params;

    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    const { submission_id } = await request.json();
    if (!submission_id) return NextResponse.json({ error: "Missing submission_id" }, { status: 400 });

    try {
        const { data: task } = await supabase
            .from("tasks")
            .select("id, status, startup_id, difficulty_level, title")
            .eq("id", taskId)
            .single();

        if (!task) return NextResponse.json({ error: "Task not found" }, { status: 404 });
        if (task.startup_id !== user.id) return NextResponse.json({ error: "Unauthorized" }, { status: 403 });
        if (task.status !== "evaluating" && task.status !== "open") {
            return NextResponse.json({ error: "Task is not open for awarding" }, { status: 400 });
        }

        const { data: submission } = await supabase
            .from("submissions")
            .select("developer_id")
            .eq("id", submission_id)
            .single();

        if (!submission) return NextResponse.json({ error: "Submission not found" }, { status: 404 });

        const bountyAmount = (task.difficulty_level * 150) + 200;
        const xpGain = task.difficulty_level * 100;

        // Create transaction record
        const { data: tx, error: txError } = await supabase
            .from("transactions")
            .insert({
                sender_id: user.id,
                receiver_id: submission.developer_id,
                amount: bountyAmount,
                status: "completed",
                task_id: taskId,
            })
            .select()
            .single();

        if (txError) throw txError;

        // Award XP & balance to developer
        const { data: devProfile } = await supabase
            .from("profiles")
            .select("reputation_score, wallet_balance")
            .eq("id", submission.developer_id)
            .single();

        await supabase
            .from("profiles")
            .update({
                reputation_score: (devProfile?.reputation_score ?? 0) + xpGain,
                wallet_balance: (devProfile?.wallet_balance ?? 0) + bountyAmount,
            })
            .eq("id", submission.developer_id);

        // Log reputation history
        await supabase.from("reputation_history").insert({
            user_id: submission.developer_id,
            amount: xpGain,
            reason: `Completed Mission: ${task.title}`,
            reference_id: taskId,
        });

        // Close task & accept submission
        await supabase.from("tasks").update({ status: "closed" }).eq("id", taskId);
        await supabase.from("submissions").update({ status: "accepted" }).eq("id", submission_id);

        // Notify developer
        await supabase.from("notifications").insert({
            user_id: submission.developer_id,
            type: "payment_received",
            title: "Bounty Awarded!",
            message: `You earned $${bountyAmount} and ${xpGain} XP for "${task.title}".`,
            action_link: `/dashboard/talent?view=ledger`,
        });

        return NextResponse.json({ success: true, tx_id: tx.id, awarded_bounty: bountyAmount, awarded_xp: xpGain });

    } catch (err: any) {
        console.error("[POST /api/tasks/[id]/award]", err?.message ?? err);
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
