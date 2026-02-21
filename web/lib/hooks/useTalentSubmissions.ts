
import { createClient } from "@/lib/supabase/client";
import { useEffect, useState } from "react";

export interface Submission {
    id: string;
    repo_url: string | null;
    status: 'enrolled' | 'pending' | 'processing' | 'evaluated' | 'failed';
    final_score: number | null;
    created_at: string;
    task: {
        id: string;
        title: string;
        description?: string;
        startup: {
            full_name: string;
        }
    }
}

export function useTalentSubmissions(userId: string | undefined) {
    const [submissions, setSubmissions] = useState<Submission[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchSub = async () => {
        if (!userId) {
            setLoading(false);
            return;
        }
        // Don't set loading to true here to avoid flickering on refetch, 
        // or handle it gracefully. For initial load it's already true.
        const supabase = createClient();
        const { data, error } = await supabase
            .from('submissions')
            .select(`
                id, repo_url, status, final_score, created_at,
                task:tasks!inner(id, title, description, startup:profiles(full_name))
            `)
            .eq('developer_id', userId)
            .order('created_at', { ascending: false });

        if (!error && data) {
            // Formatting to match interface
            const formatted = data.map((d: any) => ({
                id: d.id,
                repo_url: d.repo_url,
                status: d.status,
                final_score: d.final_score,
                created_at: d.created_at,
                task: {
                    id: d.task.id,
                    title: d.task.title,
                    description: d.task.description,
                    startup: Array.isArray(d.task.startup) ? d.task.startup[0] : d.task.startup
                }
            }));
            setSubmissions(formatted);
        }
        setLoading(false);
    };

    useEffect(() => {
        fetchSub();
    }, [userId]);

    return { submissions, loading, refetch: fetchSub };
}
