
import { createClient } from "@/lib/supabase/client";

export async function createStatsService() {
    const supabase = createClient();

    return {
        async getTalentStats(developerId: string) {
            // Parallel queries for performance
            const [
                { count: enrollments },
                { count: completed },
                { data: avgScoreData }
            ] = await Promise.all([
                supabase.from('submissions').select('*', { count: 'exact', head: true }).eq('developer_id', developerId).eq('status', 'enrolled'),
                supabase.from('submissions').select('*', { count: 'exact', head: true }).eq('developer_id', developerId).eq('status', 'evaluated'),
                supabase.from('submissions').select('final_score').eq('developer_id', developerId).eq('status', 'evaluated')
            ]);

            let avgScore = 0;
            if (avgScoreData && avgScoreData.length > 0) {
                const total = avgScoreData.reduce((acc, curr) => acc + (curr.final_score || 0), 0);
                avgScore = Math.floor(total / avgScoreData.length);
            }

            return {
                enrollments: enrollments || 0,
                completed: completed || 0,
                avgScore
            };
        },

        async getStartupStats(startupId: string) {
            // active drops, total subs, pending reviews
            // Implement if needed for Startup Overview
            return {};
        }
    };
}
