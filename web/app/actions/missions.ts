"use server";

import { createClient } from "@/lib/supabase/server";

export async function enrollMission(taskId: string) {
    try {
        const supabase = await createClient();

        // 1. Get the current authenticated user
        const { data: { user }, error: authError } = await supabase.auth.getUser();

        if (authError || !user) {
            console.error("[enrollMission] Auth error:", authError);
            return { error: "You must be logged in to start a mission." };
        }

        const userId = user.id;
        console.log("[enrollMission] Starting with userId:", userId, "taskId:", taskId);

        // 2. Check if already enrolled
        const { data: existing, error: checkError } = await supabase
            .from("submissions")
            .select("*")
            .eq("developer_id", userId)
            .eq("task_id", taskId)
            .maybeSingle();

        if (checkError) {
            console.error("[enrollMission] Check error:", checkError);
        }

        if (existing) {
            console.log("[enrollMission] Already enrolled:", existing);
            return { data: JSON.parse(JSON.stringify(existing)) };
        }

        console.log("[enrollMission] Creating new submission...");

        // 3. Create new enrollment
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
            console.error("[enrollMission] Insert error:", error);

            const errorMsg = error.message || "";
            const errorCode = error.code || "";

            if (errorCode === "23514" || errorMsg.includes("check constraint") || errorMsg.includes("submissions_status_check")) {
                return { error: "Unable to start mission. The mission may no longer be available. Please try refreshing." };
            }
            if (errorMsg.includes("row-level security") || errorMsg.includes("RLS")) {
                return { error: "You must be logged in to start a mission." };
            }
            if (errorCode === "23505" || errorMsg.includes("duplicate")) {
                return { error: "You're already enrolled in this mission!" };
            }
            return { error: errorMsg || "Failed to start mission. Please try again." };
        }

        console.log("[enrollMission] Success:", data);
        return { data: JSON.parse(JSON.stringify(data)) };

    } catch (e: any) {
        console.error("[enrollMission] Unexpected error:", e);
        return { error: e.message || "An unexpected error occurred." };
    }
}
