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

  const { data } = await supabaseClient.from("users").select("transaction_id")
    .eq("id", event.app_user_id).single();

  console.log(data);
  if (!data || data.transaction_id === event.original_transaction_id) {
    return new Response(
      JSON.stringify("Already processed"),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  let increment_value = 0;
  switch (event.product_id) {
    case "credit_purchase_2000":
      increment_value = 2000;
      break;
    case "credit_purchase_1000":
      increment_value = 1000;
      break;
    case "credit_purchase_500":
      increment_value = 500;
      break;
    case "credit_purchase_250":
      increment_value = 250;
      break;
    default:
      throw new Error("Invalid product_id");
  }

  const { error: incrementError } = await supabaseClient.rpc(
    "increment_purchased_credits",
    {
      user_id: event.app_user_id,
      increment_value: increment_value,
    },
  );

  if (incrementError) throw new Error(incrementError.message);

  await supabaseClient.from("users").update({
    transaction_id: event.original_transaction_id,
  })
    .eq("id", event.app_user_id);

  return new Response(
    JSON.stringify("Sucess"),
    { headers: { "Content-Type": "application/json" } },
  );
});
