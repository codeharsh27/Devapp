import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { fetchApi } from "@/lib/apiClient";

export interface Candidate {
    id: string;
    missionTitle: string;
    developerName: string;
    developerAvatarInitials: string;
    developerColor: string;
    status: string;
    submittedAt: string;
    repoUrl: string;
    liveUrl?: string;
    matchScore: number;
    aiSummary: string;
    technologies: string[];
    task_id: string;
    developer_id: string;
    developerUpiId: string;
}

const colors = ["emerald", "blue", "pink", "amber", "purple", "indigo"];

export function useCandidates() {
    const [candidates, setCandidates] = useState<Candidate[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    const fetchCandidates = async () => {
        setLoading(true);
        try {
            const supabase = createClient();
            const { data: { session } } = await supabase.auth.getSession();
            const token = session?.access_token;

            if (!token) throw new Error("Not authenticated");

            // Fetch from FastAPI
            const submissions: any[] = await fetchApi('/users/me/candidates', { token });

            // Map the data to what CandidatesView expects
            const formatted = submissions.map(sub => {
                const devName = sub.developer?.full_name || sub.developer?.email || "Unknown Developer";
                const initials = devName.substring(0, 2).toUpperCase();
                const color = colors[devName.length % colors.length];

                // Convert backend enum statuses back to frontend friendly strings
                let fbStatus: any = "Pending Review";
                if (sub.status === "EVALUATED") fbStatus = "Shortlisted";
                if (sub.status === "HIRED") fbStatus = "Accepted";
                if (sub.status === "FAILED") fbStatus = "Rejected";

                // We can parse the aiSummary from backend feedback
                const aiSummary = sub.feedback || (sub.ai_score ? `AI Auto-evaluated with score: ${sub.ai_score}` : "No feedback provided.");

                return {
                    id: sub.id,
                    task_id: sub.task.id,
                    developer_id: sub.developer?.id || 'unknown',
                    missionTitle: sub.task?.title || "Unknown Mission",
                    developerName: devName,
                    developerAvatarInitials: initials,
                    developerColor: color,
                    status: fbStatus,
                    submittedAt: new Date(sub.created_at).toLocaleDateString(),
                    repoUrl: sub.repo_url || "",
                    liveUrl: sub.demo_url || "",
                    matchScore: sub.final_score || sub.ai_score || 0,
                    aiSummary: aiSummary,
                    technologies: sub.task?.requirements || ["Unknown"],
                    developerUpiId: sub.developer?.upi_id || ""
                };
            });

            setCandidates(formatted);
            setError(null);
        } catch (err: any) {
            console.error("Failed to fetch candidates:", err);
            setError(err.message || "An error occurred");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchCandidates();
    }, []);

    // Also return a function if we need to manually trigger refresh, like after paying
    return { candidates, loading, error, refresh: fetchCandidates };
}
