import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";
import { updateStudySession } from "./subfunctions/studySessions.ts";
import { updateChallengeProgress } from "./subfunctions/challenges.ts";
import { updateGoalProgress } from "./subfunctions/goals.ts";
import { calculateStudyTime } from "./subfunctions/utils.ts";
import { updateStudyDays } from "./subfunctions/studyDays.ts";
import { updateUserXP } from "./subfunctions/xp.ts";

export type SessionData = {
  sessionDate: string;
  start_time: string;
  end_time: string;
};

const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
const supabaseClient = createClient(supabaseUrl, supabaseServiceRoleKey);

Deno.serve(async (req) => {
  const sessionData: SessionData = await req.json();
  const user_id = await authenticateUser(req);

  const studyDuration = calculateStudyTime(
    sessionData.start_time,
    sessionData.end_time,
  );

  await updateStudySession(
    supabaseClient,
    user_id,
    sessionData,
    studyDuration,
  );

  await updateStudyDays(
    supabaseClient,
    user_id,
    sessionData.start_time,
    studyDuration,
  );

  const goalXP = await updateGoalProgress(
    supabaseClient,
    user_id,
    sessionData.start_time,
    studyDuration,
  );

  const challengeXP = await updateChallengeProgress(
    supabaseClient,
    user_id,
    sessionData,
  );

  console.log("Total XP:", goalXP + challengeXP + studyDuration);
  await updateUserXP(
    supabaseClient,
    user_id,
    goalXP + challengeXP + studyDuration,
  );

  return new Response(
    JSON.stringify("Sucess"),
    { headers: { "Content-Type": "application/json" } },
  );
});

async function authenticateUser(req: Request): Promise<string> {
  // Authenticate user
  const authHeader = req.headers.get("Authorization")?.replace("Bearer ", "");
  if (!authHeader) throw new Error("Authorization header missing");

  const { data: userData, error: userError } = await supabaseClient.auth
    .getUser(authHeader);
  if (userError) throw new Error(userError.message);

  return userData.user.id;
}
