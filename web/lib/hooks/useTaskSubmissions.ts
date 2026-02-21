
import { createClient } from "@/lib/supabase/client";
import { useEffect, useState } from "react";

export interface TaskSubmission {
    id: string;
    repo_url: string | null;
    notes: string | null;
    status: string;
    final_score: number | null;
    created_at: string;
    developer: {
        id: string;
        full_name: string;
        avatar_url: string | null;
        email: string;
    }
}

export function useTaskSubmissions(taskId: string | null) {
    const [submissions, setSubmissions] = useState<TaskSubmission[]>([]);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        if (!taskId) return;
        setLoading(true);

        const fetchSub = async () => {
            const supabase = createClient();
            const { data, error } = await supabase
                .from('submissions')
                .select(`
                    id, repo_url, notes, status, final_score, created_at,
                    developer:profiles(id, full_name, avatar_url, email)
                `)
                .eq('task_id', taskId)
                .order('created_at', { ascending: false });

            if (!error && data) {
                // Format
                const formatted = data.map((d: any) => ({
                    ...d,
                    developer: Array.isArray(d.developer) ? d.developer[0] : d.developer
                }));
                setSubmissions(formatted);
            }
            setLoading(false);
        };
        fetchSub();
    }, [taskId]);

    return { submissions, loading, refresh: () => { } }; // refresh placeholder
}
