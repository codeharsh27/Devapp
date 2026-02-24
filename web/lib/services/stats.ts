
import { createClient } from "@/lib/supabase/client";
import { fetchApi } from "@/lib/apiClient";

export async function createStatsService() {
    const supabase = createClient();
    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;

    return {
        async getTalentStats(developerId: string) {
            try {
                // Fetch stats from FastAPI Backend
                const stats: any = await fetchApi('/users/me/stats', { token });

                // The frontend expects: enrollments, completed, avgScore
                // We'll need to calculate enrollments and avgScore by fetching submissions 
                // Alternatively, backend /users/me/submissions can be used to manually count
                const submissions: any[] = await fetchApi('/users/me/submissions', { token });

                const enrolled = submissions.filter(s => s.status === 'ENROLLED' || s.status === 'enrolled').length;
                const evaluated = submissions.filter(s => s.status === 'EVALUATED' || s.status === 'evaluated');
                const completed = evaluated.length;

                let avgScore = 0;
                if (completed > 0) {
                    const totalScore = evaluated.reduce((acc, curr) => acc + (curr.final_score || 0), 0);
                    avgScore = Math.floor(totalScore / completed);
                }

                return {
                    enrollments: enrolled,
                    completed: completed,
                    avgScore
                };
            } catch (error) {
                console.error("Failed to fetch talent stats:", error);
                return { enrollments: 0, completed: 0, avgScore: 0 };
            }
        },

        async getStartupStats(startupId: string) {
            // active drops, total subs, pending reviews
            // Implement if needed for Startup Overview
            return {};
        }
    };
}
