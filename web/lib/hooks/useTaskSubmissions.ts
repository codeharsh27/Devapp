
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
        email?: string;
    }
}

export function useTaskSubmissions(taskId: string | null) {
    const [submissions, setSubmissions] = useState<TaskSubmission[]>([]);
    const [loading, setLoading] = useState(false);
    const [refreshTrigger, setRefreshTrigger] = useState(0);

    const refresh = () => setRefreshTrigger(t => t + 1);

    useEffect(() => {
        if (!taskId) return;
        setLoading(true);

        const fetchSub = async () => {
            try {
                const res = await fetch(`/api/tasks/${taskId}/submissions`);
                if (res.ok) {
                    const json = await res.json();
                    if (json.submissions) {
                        const formatted = json.submissions.map((d: any) => ({
                            ...d,
                            developer: Array.isArray(d.developer) ? d.developer[0] : d.developer
                        }));
                        setSubmissions(formatted);
                    }
                }
            } catch (error) {
                console.error("Failed to fetch task submissions", error);
            } finally {
                setLoading(false);
            }
        };
        fetchSub();
    }, [taskId, refreshTrigger]);

    return { submissions, loading, refresh };
}
