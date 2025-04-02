import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { SessionData } from "../index.ts";

type ChallengeCondition =
  | { type: "daily_sessions"; target: number }
  | { type: "streak_days"; target: number }
  | { type: "total_hours"; target: number }
  | { type: "total_sessions"; target: number };

type Challenge = {
  id: string;
  condition: ChallengeCondition;
  reward_xp: number;
  repeatable: boolean;
};

export async function updateChallengeProgress(
  supabase: SupabaseClient,
  userId: string,
  session: SessionData,
) {
  const { data: challenges } = await supabase
    .from("challenges")
    .select("*");

  if (!challenges) {
    console.error("No challenges found");
    return;
  }
  //TODO: Add filter to only get challenges that are active and not completed

  for (const challenge of challenges) {
    const { type } = challenge.condition;

    const dispatcher: Record<string, Function> = {
      daily_sessions: handleDailySessions,
      streak_days: handleStreakDays,
      total_hours: handleTotalHours,
      total_sessions: handleTotalSessions,
    };

    if (dispatcher[type]) {
      await dispatcher[type](supabase, userId, challenge, session);
    }
  }
}

async function handleDailySessions(
  supabase: SupabaseClient,
  userId: string,
  challenge: Challenge,
  session: SessionData,
) {
  const { sessionDate } = session;
  const { target } = challenge.condition;

  const { count } = await supabase
    .from("study_sessions")
    .select("id", { count: "exact", head: true })
    .eq("user_id", userId)
    .gte("start_time", sessionDate + "T00:00:00Z")
    .lte("end_time", sessionDate + "T23:59:59Z");

  setChallengeProgress(supabase, userId, challenge.id, count);
}

async function handleStreakDays(
  supabase: SupabaseClient,
  userId: string,
  challenge: Challenge,
  session: SessionData,
) {
}

async function handleTotalHours(
  supabase: SupabaseClient,
  userId: string,
  challenge: Challenge,
  session: SessionData,
) {
}

async function handleTotalSessions(
  supabase: SupabaseClient,
  userId: string,
  challenge: Challenge,
  session: SessionData,
) {
}

async function setChallengeProgress(
  supabase: SupabaseClient,
  userId: String,
  challenge_id: string,
  progress: number,
) {
  //TODO: Upsert into challenge_progress table

  //TODO: Add trigger to move to completed_challenges table if progress >= target
}
