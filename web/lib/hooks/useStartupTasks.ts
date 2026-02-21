"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

// This file wraps the "Tasks Service" for client-side consumption
// Alternatively, we could use Server Actions.

export interface Task {
    id: string;
    title: string;
    category: string;
    status: string;
    submissions: number;
    difficulty_level?: number;
    bounty_amount?: number;
    created_at: string;
}

export function useStartupTasks(startupId: string | undefined) {
    const [tasks, setTasks] = useState<Task[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        if (!startupId) return;

        const fetchTasks = async () => {
            setLoading(true);
            const supabase = createClient();

            const { data, error } = await supabase
                .from('tasks')
                .select(`
          id, title, category, status, difficulty_level, created_at,
          submissions(count)
        `)
                .eq('startup_id', startupId)
                .order('created_at', { ascending: false });

            if (error) {
                setError(error.message);
            } else {
                const mapped = data.map((t: any) => ({
                    id: t.id,
                    title: t.title,
                    category: t.category,
                    status: t.status,
                    created_at: t.created_at,
                    difficulty_level: t.difficulty_level,
                    bounty_amount: t.bounty_amount,
                    submissions: t.submissions?.[0]?.count || 0
                }));
                setTasks(mapped);
            }
            setLoading(false);
        };

        fetchTasks();
    }, [startupId]);

    return { tasks, loading, error };
}
