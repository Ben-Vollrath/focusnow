import { SupabaseClient } from "jsr:@supabase/supabase-js@2";

export async function updateStudyDays(
  supabase: SupabaseClient,
  userId: string,
  start_time: string,
  durationMinutes: number,
) {
  const sessionDate = new Date(start_time);
  const dateString = sessionDate.toISOString().slice(0, 10); // "YYYY-MM-DD"
  const yesterdayDate = new Date(sessionDate);
  yesterdayDate.setDate(sessionDate.getDate() - 1);
  const yesterdayString = yesterdayDate.toISOString().slice(0, 10);

  // 2. Update study day
  await supabase.rpc("update_study_day", {
    p_user_id: userId,
    p_study_date: dateString,
    p_yesterday_date: yesterdayString,
    p_duration_minutes: durationMinutes,
  });
}
