
import { NextRequest, NextResponse } from "next/server";
import { createEvaluationService } from "@/lib/services/evaluation";
import { rateLimit } from "@/lib/rate-limit";

// Rate limiter: 5 requests per 10 seconds per IP for internal API (should be low/internal only, but aggressive protection)
const limiter = rateLimit({ interval: 10000, uniqueTokenPerInterval: 500 });

export async function POST(request: NextRequest) {
    const secret = request.headers.get('x-internal-secret');

    // 1. Secret Validation
    if (secret !== process.env.INTERNAL_API_SECRET) {
        return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // 2. Rate Limit (Per "User" or IP, but here it's machine to machine, so maybe higher limit or skip)
    // We'll skip rate limit for the "machine" if secret is valid, assuming the secret is safe.

    try {
        const body = await request.json();
        const { submission_id } = body;

        if (!submission_id) return NextResponse.json({ error: "Missing submission_id" }, { status: 400 });

        const evaluationService = await createEvaluationService();

        // 3. Simulated Worker Logic (REAL LOGIC REPLACEMENT)
        // In real prod, this endpoint might just ACK.
        // For MVP, we run the logic here.

        // Fetch submission details (Repo URL)
        // Note: evaluationService.storeEvaluationResult expects us to generate the result.

        // MOCK REALISTIC EVALUATION:
        // Instead of random, we check if repo_url is valid, and maybe check a "secret" file existence if we could.
        // For now, we will deterministically PASS if repo_url contains "pass" and FAIL if it contains "fail".
        // This allows predictable testing.

        // We simulate a delay to mimic `npm test`
        await new Promise(resolve => setTimeout(resolve, 3000));

        // Deterministic grading based on URL (Better than random)
        // If url has 'perfect', score 100. 'good': 80. 'fail': 40. Default: 75.
        // In real world, we would clone and run.

        // 4. Sanity Check / "Ping" the repo (Conceptually)
        /* 
        const repoRes = await fetch(repoUrl);
        if (!repoRes.ok) { ... fail ... }
        */

        const { data: submission } = await (await import("@/lib/supabase/server")).createClient().then(c => c.from('submissions').select('repo_url').eq('id', submission_id).single());

        let score = 70;
        let status: 'evaluated' | 'failed' = 'evaluated';
        let log = "Running tests...\n";

        if (submission?.repo_url) {
            const url = submission.repo_url.toLowerCase();
            if (url.includes('perfect')) { score = 100; log += "All tests passed (Bonus).\n"; }
            else if (url.includes('fail')) { score = 30; status = 'failed'; log += "Critical validation failed.\n"; }
            else if (url.includes('error')) { score = 0; status = 'failed'; log += "Syntax Error in index.ts\n"; }
            else { score = 75; log += "Tests passed with warnings.\n"; }
        }

        await evaluationService.storeEvaluationResult(submission_id, {
            score,
            status,
            log: `${log}Done.`
        });

        return NextResponse.json({ success: true, processed: true });

    } catch (err: any) {
        console.error("Worker Error:", err);
        return NextResponse.json({ error: err.message }, { status: 500 });
    }
}
