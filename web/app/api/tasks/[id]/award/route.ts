import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// POST /api/tasks/:id/award - Finalize Task & Pay Developer
export async function POST(
    request: NextRequest,
    { params }: { params: { id: string } }
) {
    const supabase = await createClient();
    const taskId = params.id;

    // 1. Auth Check
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
        return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // 2. Validate Request Body
    const { submission_id } = await request.json();
    if (!submission_id) return NextResponse.json({ error: "Missing submission_id" }, { status: 400 });

    try {
        // 3. Verify Ownership & Task Status
        const { data: task } = await supabase
            .from("tasks")
            .select("id, status, startup_id, difficulty_level, title")
            .eq("id", taskId)
            .single();

        if (!task) return NextResponse.json({ error: "Task not found" }, { status: 404 });
        if (task.startup_id !== user.id) return NextResponse.json({ error: "Unauthorized" }, { status: 403 });
        if (task.status !== 'evaluating' && task.status !== 'open') return NextResponse.json({ error: "Task is not open for awarding" }, { status: 400 });

        // 4. Get Developer Info
        const { data: submission } = await supabase
            .from("submissions")
            .select("developer_id")
            .eq("id", submission_id)
            .single();

        if (!submission) return NextResponse.json({ error: "Submission not found" }, { status: 404 });

        // 5. TRANSACTION: Start a Supabase transaction (if using RPC) or sequential updates
        // For MVP, sequential is fine.

        const bountyAmount = (task.difficulty_level * 150) + 200; // Recalculate server-side
        const xpGain = task.difficulty_level * 100; // 100 XP per level

        // A. Create Transaction Record
        const { data: tx, error: txError } = await supabase
            .from("transactions")
            .insert({
                sender_id: user.id,
                receiver_id: submission.developer_id,
                amount: bountyAmount,
                status: 'completed', // Mock success
                task_id: taskId
            })
            .select()
            .single();

        if (txError) throw txError;

        // B. Award XP & Money to Developer
        // Fetch current profile first to increment
        const { data: devProfile } = await supabase.from("profiles").select("reputation_score, wallet_balance").eq("id", submission.developer_id).single();

        const newXP = (devProfile?.reputation_score || 0) + xpGain;
        const newBalance = (devProfile?.wallet_balance || 0) + bountyAmount;

        await supabase.from("profiles")
            .update({ reputation_score: newXP, wallet_balance: newBalance })
            .eq("id", submission.developer_id);

        // C. Log Reputation History
        await supabase.from("reputation_history").insert({
            user_id: submission.developer_id,
            amount: xpGain,
            reason: `Completed Mission: ${task.title}`,
            reference_id: taskId
        });

        // D. Close Task & Accept Submission
        await supabase.from("tasks").update({ status: 'closed' }).eq("id", taskId);
        await supabase.from("submissions").update({ status: 'accepted' }).eq("id", submission_id); // Add 'accepted' to enum if needed, or just leave as evaluated+closed

        // E. Notify Developer
        await supabase.from("notifications").insert({
            user_id: submission.developer_id,
            type: 'payment_received',
            title: 'Bounty Awarded!',
            message: `You earned $${bountyAmount} and ${xpGain} XP for "${task.title}".`,
            action_link: `/dashboard/talent?view=ledger`
        });

        return NextResponse.json({ success: true, tx_id: tx.id, awarded_bounty: bountyAmount, awarded_xp: xpGain });

    } catch (err: any) {
        console.error("Award Error:", err);
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
