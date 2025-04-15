import { SupabaseClient } from "jsr:@supabase/supabase-js@2";

export async function updateUserXP(
  supabase: SupabaseClient,
  userId: string,
  xpGained: number,
) {
  const { error } = await supabase.rpc("increment_user_xp", {
    p_user_id: userId,
    amount: xpGained,
  });

  if (error) {
    console.error("Error updating user XP:", error);
  } else {
    console.log("User XP updated successfully");
  }
}
