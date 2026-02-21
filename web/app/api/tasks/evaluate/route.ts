
import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: NextRequest) {
    try {
        const body = await request.json();
        const { submissionId } = body;

        if (!submissionId) return NextResponse.json({ error: "Missing submissionId" }, { status: 400 });

        const supabase = await createClient();

        // 1. Fetch Submission & Task Criteria
        const { data: submission, error: subError } = await supabase
            .from('submissions')
            .select(`
                id,
                task:tasks (
                    id,
                    criteria
                )
            `)
            .eq('id', submissionId)
            .single();

        if (subError || !submission) {
            return NextResponse.json({ error: "Submission not found" }, { status: 404 });
        }

        // @ts-ignore
        const taskData = Array.isArray(submission.task) ? submission.task[0] : submission.task;
        const criteria = taskData?.criteria || [];

        // 2. Simulate Evaluation against Criteria
        let totalScore = 0;
        const breakdown = [];

        if (criteria.length > 0) {
            for (const c of criteria) {
                // Mock score for this criterion (60-100 range)
                const rawScore = Math.floor(Math.random() * 40) + 60;
                const weighted = rawScore * (c.weight || 0);
                totalScore += weighted;
                breakdown.push({ ...c, score: rawScore, weighted_score: weighted });
            }
        } else {
            // Fallback if no criteria
            totalScore = Math.floor(Math.random() * 40) + 60;
        }

        // Simulate delay
        await new Promise(resolve => setTimeout(resolve, 2000));

        // 3. Update Submission
        await supabase
            .from('submissions')
            .update({
                status: 'evaluated',
                final_score: Math.round(totalScore)
            })
            .eq('id', submissionId);

        return NextResponse.json({ success: true, score: Math.round(totalScore), breakdown });
    } catch (e: any) {
        return NextResponse.json({ error: e.message }, { status: 500 });
    }
}
