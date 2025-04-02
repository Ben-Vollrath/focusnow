import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";
import { updateStudySession } from "./utils/studySessions.ts";
import { updateChallengeProgress } from "./utils/challenges.ts";

export type SessionData = {
  sessionDate: string;
  durationMinutes: number;
  start_time: string;
  end_time: string;
};

const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
const supabaseClient = createClient(supabaseUrl, supabaseServiceRoleKey);

Deno.serve(async (req) => {
  const sessionData: SessionData = await req.json();
  const user_id = await authenticateUser(req);

  updateStudySession(supabaseClient, user_id, sessionData);
  updateChallengeProgress(supabaseClient, user_id, sessionData);

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

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/handle-completed-study-session' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
