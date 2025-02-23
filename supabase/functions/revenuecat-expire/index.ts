import { createClient } from "jsr:@supabase/supabase-js@2";
/// <reference types="https://esm.sh/@supabase/functions-js/src/edge-runtime.d.ts" />

const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
const supabaseClient = createClient(supabaseUrl, supabaseServiceRoleKey);
const revenuecatAuth = Deno.env.get("revenuecat-auth") || "";

Deno.serve(async (req) => {
  const auth = req.headers.get("Authorization");

  if (auth != revenuecatAuth) {
    return new Response(
      JSON.stringify("Unauthorized"),
      { status: 401, headers: { "Content-Type": "application/json" } },
    );
  }

  const { event } = await req.json();
  console.log(event);

  await supabaseClient.from("users").update({
    transaction_id: event.original_transaction_id,
    isPremium: false,
    credits: 3,
  })
    .eq("id", event.app_user_id);

  return new Response(
    JSON.stringify("Success"),
    { headers: { "Content-Type": "application/json" } },
  );
});
