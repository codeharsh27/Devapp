
import { createClient } from "@/lib/supabase/server";
import { fetchApi } from "@/lib/apiClient";

// Server-side version of createTasksService
export async function createServerTasksService() {
    const supabase = await createClient();
    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;

    return {
        async getStartupTasks(startupId: string) {
            // Fetch tasks for startup from FastAPI
            const tasks: any[] = await fetchApi('/api/v1/tasks', { token });
            // For now, filter here if backend returns all, or implement on backend
            const startupTasks = tasks.filter(t => t.startup_id === startupId);
            return startupTasks.map((task: any) => ({
                ...task,
                submissions: 0 // Will need to get this from backend
            }));
        },

        async createTask(unusedUserId: string, taskData: any) {
            // Validation: Verify User is Startup handled by backend JWT automatically
            const data = await fetchApi('/api/v1/tasks', {
                method: 'POST',
                token,
                body: JSON.stringify({
                    title: taskData.title,
                    description: taskData.description,
                    bounty_amount: taskData.bounty_amount || 0,
                    category: taskData.category || "backend",
                    difficulty_level: taskData.difficulty_level || 1,
                    estimated_hours: 0,
                    status: 'OPEN', // TaskStatus enum matching backend
                    repo_url: taskData.repo_url,
                    requirements: taskData.requirements || [],
                    is_promoted: taskData.is_promoted || false,
                    deadline: taskData.deadline || null,
                    max_submissions: taskData.max_submissions || null
                })
            });
            return data;
        },

        async getOpenTasks(filters?: { category?: string, limit?: number }) {
            const tasks: any[] = await fetchApi('/api/v1/tasks', { token });
            let openTasks = tasks.filter(t => t.status === 'OPEN' || t.status === 'open');

            if (filters?.category) {
                openTasks = openTasks.filter(t => t.category === filters.category);
            }
            if (filters?.limit) {
                openTasks = openTasks.slice(0, filters.limit);
            }
            return openTasks.map(t => ({ ...t, startup: { full_name: "Startup", avatar_url: "" } }));
        }
    };
}
