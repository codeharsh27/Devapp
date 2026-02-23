"use server";

import { createClient } from "@/lib/supabase/server";

export async function deleteMission(taskId: string) {
    try {
        const supabase = await createClient();
        const { data: { user }, error: authError } = await supabase.auth.getUser();

        if (authError || !user) {
            return { error: "Authentication failed. Please log in." };
        }

        const { error } = await supabase
            .from("tasks")
            .delete()
            .eq("id", taskId)
            .eq("user_id", user.id); // Secure: only the creator can delete

        if (error) {
            console.error("[deleteMission] Delete error:", error);
            return { error: error.message || "Failed to delete mission." };
        }

        return { success: true };
    } catch (e: any) {
        console.error("[deleteMission] Unexpected error:", e);
        return { error: "An unexpected error occurred." };
    }
}

export async function updateMissionStatus(taskId: string, newStatus: string) {
    try {
        const supabase = await createClient();
        const { data: { user }, error: authError } = await supabase.auth.getUser();

        if (authError || !user) {
            return { error: "Authentication failed." };
        }

        const { error } = await supabase
            .from("tasks")
            .update({ status: newStatus, updated_at: new Date().toISOString() })
            .eq("id", taskId)
            .eq("user_id", user.id);

        if (error) {
            console.error("[updateMissionStatus] error:", error);
            return { error: error.message || "Failed to update mission." };
        }

        return { success: true };
    } catch (e: any) {
        console.error("[updateMissionStatus] Unexpected:", e);
        return { error: "An unexpected error occurred." };
    }
}
