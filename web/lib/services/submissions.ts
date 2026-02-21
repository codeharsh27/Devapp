
import { createClient } from "@/lib/supabase/client";

export async function createSubmissionsService() {
    const supabase = createClient();

    return {
        async enroll(developerId: string, taskId: string) {
            // Check if already enrolled
            const { data: existing } = await supabase
                .from('submissions')
                .select('id')
                .eq('developer_id', developerId)
                .eq('task_id', taskId)
                .maybeSingle();

            if (existing) return existing;

            const { data, error } = await supabase
                .from('submissions')
                .insert({
                    developer_id: developerId,
                    task_id: taskId,
                    status: 'enrolled'
                })
                .select()
                .single();

            if (error) throw error;
            return data;
        },

        async submitWork(submissionId: string, data: { repo_url: string, notes?: string }) {
            const { error } = await supabase
                .from('submissions')
                .update({
                    repo_url: data.repo_url,
                    notes: data.notes,
                    status: 'pending' // Move to pending for evaluation
                })
                .eq('id', submissionId);

            if (error) throw error;
        },

        async getTalentSubmissions(developerId: string) {
            const { data, error } = await supabase
                .from('submissions')
                .select(`
            *,
            task:tasks(id, title, status, startup:profiles(full_name))
          `)
                .eq('developer_id', developerId)
                .order('created_at', { ascending: false });

            if (error) throw error;
            return data;
        },

        async getTaskSubmissions(taskId: string) {
            const { data, error } = await supabase
                .from('submissions')
                .select(`
             *,
             developer:profiles(full_name, avatar_url, email)
           `)
                .eq('task_id', taskId)
                .neq('status', 'enrolled') // Only show actual submissions? Or enrolled too? Maybe both.
                .order('created_at', { ascending: false });

            if (error) throw error;
            return data;
        }
    };
}
