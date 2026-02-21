
import { createClient } from "@/lib/supabase/client";
import { isStartupRole } from "@/lib/auth/roles";

export async function createTasksService() {
    const supabase = createClient();

    return {
        async getStartupTasks(startupId: string) {
            const { data, error } = await supabase
                .from('tasks')
                .select(`
          id, title, category, status, difficulty_level, 
          submissions:submissions(count)
        `)
                .eq('startup_id', startupId)
                .order('created_at', { ascending: false });

            if (error) throw error;

            // Transform for UI
            return data.map((t: any) => ({
                ...t,
                submissions: t.submissions?.[0]?.count || 0,
                urgent: false, // Compute based on deadline?
                topExecutions: false
            }));
        },

        async createTask(userId: string, taskData: any) {
            // Verify role again (Service layer security)
            const { data: profile } = await supabase
                .from('profiles')
                .select('role')
                .eq('id', userId)
                .single();

            if (!profile || !isStartupRole(profile.role)) {
                throw new Error('Unauthorized');
            }

            const { data, error } = await supabase
                .from('tasks')
                .insert({
                    startup_id: userId,
                    ...taskData,
                    repo_template_url: taskData.repo_template_url || null, // handle optional
                })
                .select()
                .single();

            if (error) throw error;
            return data;
        },

        async getTaskById(taskId: string) {
            const { data, error } = await supabase
                .from('tasks')
                .select(`*, startup:profiles(full_name, avatar_url)`)
                .eq('id', taskId)
                .single();

            if (error) throw error;
            return data;
        },

        async getOpenTasks(filters?: { category?: string, limit?: number }) {
            let query = supabase
                .from('tasks')
                .select(`*, startup:profiles(full_name, avatar_url)`)
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
