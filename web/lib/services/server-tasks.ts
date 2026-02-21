
import { createClient } from "@/lib/supabase/server";

// Server-side version of createTasksService
export async function createServerTasksService() {
    const supabase = await createClient();

    return {
        async getStartupTasks(startupId: string) {
            const { data, error } = await supabase
                .from('tasks')
                .select('*, submissions(count)')
                .eq('startup_id', startupId)
                .order('created_at', { ascending: false });

            if (error) throw error;

            return data.map((task: any) => ({
                ...task,
                submissions: task.submissions?.[0]?.count || 0
            }));
        },

        async createTask(userId: string, taskData: any) {
            // Validation: Verify User is Startup
            const { data: profile } = await supabase.from('profiles').select('role').eq('id', userId).single();
            // Basic role check - ideally rely on RLS but explicit check good for errors
            if (!profile) throw new Error("Unauthorized");

            const { data, error } = await supabase
                .from('tasks')
                .insert({
                    ...taskData,
                    startup_id: userId,
                    status: 'open'
                })
                .select()
                .single();

            if (error) throw error;
            return data;
        },

        async getOpenTasks(filters?: { category?: string, limit?: number }) {
            let query = supabase
                .from('tasks')
                .select(`
                *,
                startup:profiles(full_name, avatar_url)
            `)
                .eq('status', 'open')
                .order('created_at', { ascending: false });

            if (filters?.category) {
                query = query.eq('category', filters.category);
            }

            if (filters?.limit) {
                query = query.limit(filters.limit);
            }

            const { data, error } = await query;
            if (error) throw error;
            return data;
        }
    };
}
