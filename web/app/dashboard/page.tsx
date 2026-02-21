
import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";

export default async function DashboardRedirect() {
    const supabase = await createClient();

    const {
        data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
        redirect("/auth");
    }

    // STRICT CHECK: Fetch role from database
    // We do NOT rely on metadata here to ensure consistency with DB
    const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();

    if (!profile || !profile.role) {
        // Edge case: User exists but no profile or role
        // Redirect to onboarding to fix/complete profile
        redirect("/onboarding");
    }

    if (profile.role === 'Founder' || profile.role === 'Co-Founder' || user.user_metadata?.user_type === 'startup') {
        redirect("/startup/dashboard");
    }

    // Default to talent dashboard for everyone else
    redirect("/talent/dashboard");

    // Fallback if role is invalid or unknown
    redirect("/onboarding");
}
