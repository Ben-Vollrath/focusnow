import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

export type GoalData = {
  target_date: string | undefined;
  target_minutes: number;
  name: string;
};

const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
const supabaseClient = createClient(supabaseUrl, supabaseServiceRoleKey);

Deno.serve(async (req) => {
  const goalData: GoalData = await req.json();
  const user_id = await authenticateUser(req);

  // Create goal for user
  const { error: insertError } = await supabaseClient
    .from("goals")
    .insert({
      user_id,
      name: goalData.name,
      target_date: goalData.target_date,
      target_minutes: goalData.target_minutes,
      xp_reward: Math.round(goalData.target_minutes / 60),
    });

  if (insertError) {
    return new Response(
      JSON.stringify({ error: insertError.message }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

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
