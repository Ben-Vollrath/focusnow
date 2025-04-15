import { SupabaseClient } from "jsr:@supabase/supabase-js@2";

export async function updateGoalProgress(
  supabase: SupabaseClient,
  userId: string,
  sessionDate: string,
  sessionDuration: number,
) {
  const { data: goalXpResult, error: goalXpError } = await supabase
    .rpc("update_goal_progress", {
      p_user_id: userId,
      p_session_date: sessionDate,
      p_duration_minutes: sessionDuration,
    });

  if (goalXpError) {
    console.error("Failed to update goal progress:", goalXpError);
  }
  return goalXpResult;
}
