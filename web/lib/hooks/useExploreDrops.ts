
import { createClient } from "@/lib/supabase/client";
import { useEffect, useState } from "react";

export function useExploreDrops() {
    const [drops, setDrops] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchDrops = async () => {
            const supabase = createClient();
            const { data, error } = await supabase
                .from('tasks')
                .select(`
                    *,
                    startup:profiles(full_name, avatar_url)
                `)
                .eq('status', 'open') // Only show open drops
                .order('created_at', { ascending: false });

            if (!error && data) {
                setDrops(data);
            }
            setLoading(false);
        };
        fetchDrops();
    }, []);

    return { drops, loading };
}
