
import { createClient } from "@/lib/supabase/client";
import { useEffect, useState } from "react";

export function useTalentStats(userId: string | undefined) {
    const [stats, setStats] = useState({ enrollments: 0, completed: 0, avgScore: 0, activeSubmissions: [] as any[] });
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (!userId) return;

        // Creating client-side fetcher or could use an API route if we want to obscure logic
        // But RLS allows reading own submissions, so direct client query is fine & faster.
        const fetchStats = async () => {
            const supabase = createClient();

            // 1. Enrollments
            const { count: enrollments } = await supabase
                .from('submissions')
                .select('*', { count: 'exact', head: true })
                .eq('developer_id', userId)
                .in('status', ['enrolled', 'pending']); // active

            // 2. Completed
            const { count: completed } = await supabase
                .from('submissions')
                .select('*', { count: 'exact', head: true })
                .eq('developer_id', userId)
                .eq('status', 'evaluated');

            // 3. Avg Score
            const { data: scores } = await supabase
                .from('submissions')
                .select('final_score')
                .eq('developer_id', userId)
                .eq('status', 'evaluated');

            let avgScore = 0;
            if (scores && scores.length > 0) {
                const total = scores.reduce((acc, curr) => acc + (curr.final_score || 0), 0);
                avgScore = Math.floor(total / scores.length);
            }

            // 4. Fetch Active Submissions for Dashboard Stream
            const { data: activeSubs } = await supabase
                .from('submissions')
                .select(`
                    id, status, created_at,
                    task:tasks!inner(title, category)
                `)
                .eq('developer_id', userId)
                .in('status', ['enrolled', 'pending', 'processing'])
                .order('created_at', { ascending: false })
                .limit(3);

            setStats({
                enrollments: enrollments || 0,
                completed: completed || 0,
                avgScore,
                activeSubmissions: activeSubs || []
            });
            setLoading(false);
        };

        fetchStats();
    }, [userId]);

    return { stats, loading };
}
