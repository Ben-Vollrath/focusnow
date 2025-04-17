import {
    assertEquals,
    assertExists,
} from "https://deno.land/std@0.192.0/testing/asserts.ts";
import { withAnonymousTestUser } from "./test-utils.ts";
import { delay } from "https://deno.land/std@0.192.0/async/delay.ts";

Deno.test("Edge function creates a goal for anonymous user", async () => {
    await withAnonymousTestUser(async (client, user) => {
        const goalData = {
            target_minutes: 120,
            target_date: new Date(Date.now() + 7 * 24 * 60 * 60_000) // 1 week from now
                .toISOString()
                .split("T")[0],
            name: "Test Goal",
        };

        const { data, error } = await client.functions.invoke("create-goal", {
            body: goalData,
        });

        assertEquals(error, null);
        assertEquals(data, "Sucess");

        await delay(300); // Give trigger/system time to propagate if needed

        const { data: goals, error: fetchError } = await client
            .from("goals")
            .select("*")
            .eq("user_id", user.id)
            .order("created_at", { ascending: false })
            .limit(1);

        assertEquals(fetchError, null);
        assertExists(goals?.[0]);

        const inserted = goals![0];
        assertEquals(inserted.target_minutes, goalData.target_minutes);
        assertEquals(inserted.target_date, goalData.target_date);
        assertEquals(
            inserted.xp_reward,
            Math.round(goalData.target_minutes / 60),
        );
    });
});
