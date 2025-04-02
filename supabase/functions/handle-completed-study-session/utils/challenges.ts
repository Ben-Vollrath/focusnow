import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { SessionData } from "../index.ts";

type ChallengeCategory =
  | "daily_sessions"
  | "streak_days"
  | "total_hours"
  | "total_sessions";

type Challenge = {
  id: string;
  category: ChallengeCategory;
  condition_amount: number;
  reward_xp: number;
  is_repeatable: boolean;
  difficulty: number;
};

export async function updateChallengeProgress(
  supabase: SupabaseClient,
  userId: string,
  session: SessionData,
) {
  const categories: ChallengeCategory[] = [
    "daily_sessions",
    "streak_days",
    "total_hours",
    "total_sessions",
  ];

  const activeChallenges: Challenge[] = [];

  for (const category of categories) {
    const { data, error } = await supabase
      .from("challenges")
      .select("*, challenge_progress!inner(user_id, completed)")
      .eq("challenge_progress.user_id", userId)
      .eq("challenge_progress.completed", false)
      .eq("category", category)
      .order("difficulty", { ascending: true })
      .limit(1);

    if (error) {
      console.error(
        `Error fetching challenge for category ${category}:`,
        error,
      );
      continue;
    }

    if (data && data.length > 0) {
      activeChallenges.push(data[0]);
    }
  }

  for (const challenge of activeChallenges) {
    const dispatcher: Record<ChallengeCategory, Function> = {
      daily_sessions: handleDailySessions,
      streak_days: handleStreakDays,
      total_hours: handleTotalHours,
      total_sessions: handleTotalSessions,
    };

    const handler = dispatcher[challenge.category];
    if (handler) {
      await handler(supabase, userId, challenge, session);
    }
  }
}

async function handleDailySessions(
  supabase: SupabaseClient,
  userId: string,
  challenge: Challenge,
  session: SessionData,
) {
  const { condition_amount: target } = challenge;

  // Extract the date from the session start time
  const sessionDate = new Date(session.start_time).toISOString().slice(0, 10);

  // Fetch today's study day record
  const { data, error } = await supabase
    .from("study_days")
    .select("total_study_sessions")
    .eq("user_id", userId)
    .eq("study_date", sessionDate)
    .single();

  if (error || !data) {
    console.error("Error fetching today's study day:", error);
    return;
  }

  const progress = data.total_study_sessions;
  await setChallengeProgress(supabase, userId, challenge.id, progress, target);
}

async function handleStreakDays(
  supabase: SupabaseClient,
  userId: string,
  challenge: Challenge,
  session: SessionData,
) {
  const { condition_amount: target } = challenge;

  // Get the date of the session
  const sessionDate = new Date(session.start_time).toISOString().slice(0, 10);

  // Look up the streak_day for this user on that date
  const { data, error } = await supabase
    .from("study_days")
    .select("streak_day")
    .eq("user_id", userId)
    .eq("study_date", sessionDate)
    .single();

  if (error || !data) {
    console.error("Failed to fetch streak day info:", error);
    return;
  }

  const progress = data.streak_day;
  await setChallengeProgress(supabase, userId, challenge.id, progress, target);
}

async function handleTotalHours(
  supabase: SupabaseClient,
  userId: string,
  challenge: Challenge,
  session: SessionData,
) {
  const { condition_amount: target } = challenge;
  const { count } = await supabase
    .from("users")
    .select("total_study_time")
    .eq("user_id", userId);

  if (!count) return;

  const progress = count;
  await setChallengeProgress(supabase, userId, challenge.id, progress, target);
}

async function handleTotalSessions(
  supabase: SupabaseClient,
  userId: string,
  challenge: Challenge,
  session: SessionData,
) {
  const { condition_amount: target } = challenge;
  const { count } = await supabase
    .from("users")
    .select("total_study_sessions")
    .eq("user_id", userId);

  if (!count) return;

  const progress = count;
  await setChallengeProgress(supabase, userId, challenge.id, progress, target);
}

async function setChallengeProgress(
  supabase: SupabaseClient,
  userId: string,
  challengeId: string,
  progress: number,
  target: number,
) {
  const isCompleted = progress >= target;

  // Upsert current challenge progress
  await supabase
    .from("challenge_progress")
    .upsert({
      user_id: userId,
      challenger_id: challengeId,
      progress,
      completed: isCompleted,
      last_updated: new Date().toISOString(),
    }, { onConflict: "user_id,challenger_id" });

  // If completed, grant XP and look for next challenge
  if (isCompleted) {
    const { data: currentChallenge } = await supabase
      .from("challenges")
      .select("reward_xp, category, difficulty")
      .eq("id", challengeId)
      .single();

    if (currentChallenge?.reward_xp) {
      await supabase.rpc("increment_user_xp", {
        p_user_id: userId,
        amount: currentChallenge.reward_xp,
      });

      await supabase.rpc("update_user_level", { p_user_id: userId });
    }

    if (!currentChallenge) {
      console.error(`Challenge with ID ${challengeId} not found.`);
      return;
    }

    // Carry over progress to next difficulty (if it exists)
    const { data } = await supabase
      .from("challenges")
      .select("id, condition_amount")
      .eq("category", currentChallenge.category)
      .gt("difficulty", currentChallenge.difficulty)
      .order("difficulty", { ascending: true })
      .limit(1);

    if (data) {
      await setChallengeProgress(
        supabase,
        userId,
        data[0].id,
        progress, // carry over raw progress
        data[0].condition_amount, // new target
      );
    }
  }
}
