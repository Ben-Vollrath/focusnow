import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { SessionData } from "../index.ts";

export async function updateStudySession(
  supabase: SupabaseClient,
  userId: string,
  session: SessionData,
) {
  const { durationMinutes, start_time, end_time } = session;

  const { error } = await supabase
    .from("study_sessions")
    .insert({
      user_id: userId,
      duration_minutes: durationMinutes,
      start_time,
      end_time,
    });

  if (error) {
    console.error("Error inserting study session:", error);
  } else {
    console.log("Study session inserted successfully");
  }
}
