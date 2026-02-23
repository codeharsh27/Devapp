
import { createClient } from "@/lib/supabase/client";

export async function createSubmissionsService() {
    const supabase = createClient();

    return {
        async enroll(userId: string, taskId: string) {
            console.log("[enroll] Starting with userId:", userId, "taskId:", taskId);
            
            // Check if already enrolled
            const { data: existing, error: checkError } = await supabase
                .from("submissions")
                .select("*")
                .eq("developer_id", userId)
                .eq("task_id", taskId)
                .maybeSingle();
            
            if (checkError) {
                console.error("[enroll] Check error:", checkError);
            }

            if (existing) {
                console.log("[enroll] Already enrolled:", existing);
                return existing;
            }

            console.log("[enroll] Creating new submission...");
            // Create new enrollment
            const { data, error } = await supabase
                .from("submissions")
                .insert({
                    developer_id: userId,
                    task_id: taskId,
                    status: "enrolled",
                })
                .select()
                .single();

            if (error) {
                console.error("[enroll] Insert error:", error);
                // Handle specific error cases with user-friendly messages
                const errorMsg = error.message || "";
                const errorCode = error.code || "";
                
                // Check constraint violation (PostgreSQL code 23514)
                if (errorCode === "23514" || errorMsg.includes("check constraint") || errorMsg.includes("submissions_status_check")) {
                    throw new Error("Unable to start mission. The mission may no longer be available. Please try refreshing.");
                }
                // RLS violation
                if (errorMsg.includes("row-level security") || errorMsg.includes("RLS")) {
                    throw new Error("You must be logged in to start a mission.");
                }
                // Duplicate entry
                if (errorCode === "23505" || errorMsg.includes("duplicate")) {
                    throw new Error("You're already enrolled in this mission!");
                }
                throw new Error(errorMsg || "Failed to start mission. Please try again.");
            }

            console.log("[enroll] Success:", data);
            return data;
        },

        async submitWork(submissionId: string, submissionData: {
            repo_url?: string;
            demo_url?: string;
            notes?: string;
        }) {
            const { data, error } = await supabase
                .from("submissions")
                .update({
                    repo_url: submissionData.repo_url,
                    demo_url: submissionData.demo_url,
                    notes: submissionData.notes,
                    status: "pending",
                })
                .eq("id", submissionId)
                .select()
                .single();

            if (error) {
                if (error.message.includes("submissions_status_check")) {
                    throw new Error("Unable to submit work. Please try again.");
                }
                throw new Error(error.message || "Failed to submit work. Please try again.");
            }

            return data;
        },

        async getSubmissions(userId: string) {
            const { data, error } = await supabase
                .from("submissions")
                .select(`
                    *,
                    task:tasks(*)
                `)
                .eq("developer_id", userId)
                .order("created_at", { ascending: false });

            if (error) {
                throw new Error(error.message || "Failed to load submissions.");
            }

            return data;
        },

        async getSubmissionById(submissionId: string) {
            const { data, error } = await supabase
                .from("submissions")
                .select(`
                    *,
                    task:tasks(*)
                `)
                .eq("id", submissionId)
                .single();

            if (error) {
                throw new Error(error.message || "Failed to load submission.");
            }

            return data;
        },
    };
}
