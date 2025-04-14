import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { SessionData } from "../index.ts";

export async function updateStudySession(
  supabase: SupabaseClient,
  userId: string,
  session: SessionData,
  durationMinutes: number,
) {
  const { start_time, end_time } = session;

  const { error } = await supabase
    .from("study_sessions")
    .insert({
      user_id: userId,
      start_time,
      end_time,
      duration: durationMinutes,
    });

  supabase.rpc("increment_user_total_information", {
    p_user_id: userId,
    p_duration_minutes: durationMinutes,
  });

  if (error) {
    console.error("Error inserting study session:", error);
  } else {
    console.log("Study session inserted successfully");
  }

  return durationMinutes;
}
