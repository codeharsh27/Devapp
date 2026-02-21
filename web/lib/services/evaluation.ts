import { createClient } from '@/lib/supabase/client';
import { isStartupRole } from '@/lib/auth/roles';

export async function createEvaluationService() {
    const supabase = createClient();

    return {
        /**
         * Queues a submission for evaluation.
         * In MVP, we might run a synchronous check or simulate a queue.
         */
        async queueEvaluation(submissionId: string) {
            // Validate submission exists
            const { data: submission, error: subError } = await supabase
                .from('submissions')
                .select('id, repo_url, status, task_id')
                .eq('id', submissionId)
                .single();

            if (subError || !submission) {
                throw new Error('Submission not found');
            }

            if (submission.status !== 'pending' && submission.status !== 'failed') {
                // Already processed or processing
                return;
            }

            // Update status to processing
            const { error: updateError } = await supabase
                .from('submissions')
                .update({ status: 'processing' })
                .eq('id', submissionId);

            if (updateError) throw updateError;

            // MVP: Dispatch to "Worker" via Internal API (or direct function call if simpler/safer)
            // Using fetch to call our own internal API allows us to decouple "Web" from "Worker" logically
            // and apply rate limits / secrets.
            // However, for immediate feedback in MVP without a real worker, we rely on the internal API to
            // "simulate" the worker delay and update.

            const INTERNAL_API_URL = process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000';
            // Client-side cannot access internals usually, but here we invoke API endpoint.
            // WARNING: The INTERNAL SECRET should NOT be exposed on client.
            // This architecture of calling internal API from client is flawed if filtering by secret.
            // BETTER: The CLIENT updates status, and the API route (server) handles the heavy lifting/auth.
            // FOR NOW: We'll assume the evaluation trigger is backend-only or purely simulated here.

            // SIMULATION (since we are moving this to Client Component usage):
            // We can't safely call the secured internal API from client without exposing secret.
            // So we will just call a public API endpoint if exist, or just simulate for demo.

            // To fix properly: Create a public API endpoint /api/submissions/evaluate causing server-side evaluation.
            // For MVP Demo Speed: We will just simulate the success in DB directly if RLS allows, or call a Next.js API route.

            await fetch('/api/tasks/evaluate', {
                method: 'POST',
                body: JSON.stringify({ submissionId })
            });
        },

        /**
         * Securely records evaluation results.
         * Should only be called by the trusted worker (via internal API).
         */
        async storeEvaluationResult(submissionId: string, result: {
            score: number,
            log: string,
            status: 'evaluated' | 'failed'
        }) {
            const isShortlisted = result.score >= 80; // Configurable threshold

            const { error } = await supabase
                .from('submissions')
                .update({
                    status: result.status,
                    // raw_auto_score: result.score, // specific col might not exist in type
                    final_score: result.score,
                    // is_shortlisted: isShortlisted, 
                    // updated_at is handled by trigger
                })
                .eq('id', submissionId);

            if (error) throw error;

            // Add Log (if table exists and RLS permits)
            await supabase.from('evaluation_logs').insert({
                submission_id: submissionId,
                step_name: 'Automated Evaluation',
                status: result.status === 'evaluated' ? 'success' : 'failure',
                output_log: result.log,
                duration_ms: 0
            });
        }
    };
}
