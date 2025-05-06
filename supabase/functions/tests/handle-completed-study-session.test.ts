// handleCompletedStudySession.test.ts
import {
    assertEquals,
    assertExists,
} from "https://deno.land/std@0.192.0/testing/asserts.ts";
import {
    createStudySession,
    getTestServiceClient,
    withAnonymousTestUser,
} from "./test-utils.ts";
import { delay } from "https://deno.land/std@0.192.0/async/delay.ts";

const edgeFunctionName = "handle-completed-study-session";

Deno.test("Edge function inserts study session for user", async () => {
    await withAnonymousTestUser(async (client, user) => {
        const { sessionData, data, error } = await createStudySession(
            client,
            edgeFunctionName,
        );

        assertEquals(error, null);
        assertEquals(data, "Sucess");

        await delay(100);

        const { data: sessions, error: fetchError } = await client
            .from("study_sessions")
            .select("*")
            .limit(1);

        assertEquals(fetchError, null);
        assertExists(sessions?.[0]);
        assertEquals(sessions?.[0].user_id, user.id);
        assertEquals(sessions?.[0].duration, 25);
    });
});

Deno.test("User total information is updated", async () => {
    await withAnonymousTestUser(async (client, user) => {
        const { sessionData, data, error } = await createStudySession(
            client,
            edgeFunctionName,
            10,
        );

        assertEquals(error, null);
        assertEquals(data, "Sucess");

        const { data: userData, error: fetchError } = await client
            .from("users")
            .select("*");

        assertEquals(fetchError, null);
        assertExists(userData?.[0]);
        assertEquals(userData?.[0].id, user.id);
        assertEquals(userData?.[0].total_study_sessions, 1); //10 xp from session, 10 from daily sessions challenge, 10 from total sessions challenge
        assertEquals(userData?.[0].total_study_time, 10);
    });
});

Deno.test("User XP is updated", async () => {
    await withAnonymousTestUser(async (client, user) => {
        const { sessionData, data, error } = await createStudySession(
            client,
            edgeFunctionName,
            10,
        );

        assertEquals(error, null);
        assertEquals(data, "Sucess");

        const { data: userData, error: fetchError } = await client
            .from("users")
            .select("*");

        assertEquals(fetchError, null);
        assertExists(userData?.[0]);
        assertEquals(userData?.[0].id, user.id);
        assertEquals(userData?.[0].level, 1); //10 xp from session, 10 from daily sessions challenge
        assertEquals(userData?.[0].xp, 20);
    });
});

Deno.test("Edge function inserts study days for user", async () => {
    await withAnonymousTestUser(async (client, user) => {
        const { sessionData, data, error } = await createStudySession(
            client,
            edgeFunctionName,
        );

        assertEquals(error, null);
        assertEquals(data, "Sucess");

        const { data: study_days, error: fetchError } = await client
            .from("study_days")
            .select("*")
            .limit(1);

        assertEquals(fetchError, null);
        assertExists(study_days?.[0]);
        assertEquals(study_days?.[0].user_id, user.id);
        assertEquals(study_days?.[0].total_study_time, 25);

        const { data: funcData2, error: funcError2 } = await client.functions
            .invoke(
                edgeFunctionName,
                {
                    body: sessionData,
                },
            );

        assertEquals(funcError2, null);
        assertEquals(funcData2, "Sucess");

        await delay(100);

        const { data: study_days2, error: fetchError2 } = await client
            .from("study_days")
            .select("*")
            .limit(1);

        assertEquals(fetchError2, null);
        assertExists(study_days2?.[0]);
        assertEquals(study_days2?.[0].user_id, user.id);
        assertEquals(study_days2?.[0].total_study_time, 50);
    });
});

Deno.test("Daily Sessions Challenge is completed and next one unlocked", async () => {
    await withAnonymousTestUser(async (client, user) => {
        const { sessionData, data, error } = await createStudySession(
            client,
            edgeFunctionName,
            10,
        );

        assertEquals(error, null);
        assertEquals(data, "Sucess");

        // Validate user XP and level
        const { data: userData, error: fetchErrorUsers } = await client
            .from("users")
            .select("*")
            .eq("id", user.id)
            .single();

        assertEquals(fetchErrorUsers, null);
        assertExists(userData);
        assertEquals(userData.level, 1);
        assertEquals(userData.xp, 20); // 10 earned - +10 daily session challenge

        // Fetch challenge progress joined with challenge info
        const { data: challenges, error: fetchErrorChallenges } = await client
            .from("challenge_progress")
            .select("*, challenge_id(id, category, difficulty)")
            .eq("user_id", user.id);

        assertEquals(fetchErrorChallenges, null);
        assertExists(challenges);

        // Filter daily_sessions only
        const daily = challenges
            .filter((c) => c.challenge_id.category === "daily_sessions")
            .sort((a, b) =>
                a.challenge_id.difficulty - b.challenge_id.difficulty
            );

        assertEquals(daily.length, 2); // one completed, one unlocked
        assertEquals(daily[0].completed, true);
        assertEquals(daily[1].completed, false);
        assertEquals(daily[1].progress, 1);
    });
});

Deno.test("Total Sessions Challenge is completed and next one unlocked", async () => {
    await withAnonymousTestUser(async (client, user) => {
        await createStudySession(
            client,
            edgeFunctionName,
            10,
        );

        await createStudySession(
            client,
            edgeFunctionName,
            10,
        );

        await createStudySession(
            client,
            edgeFunctionName,
            10,
        );

        await createStudySession(
            client,
            edgeFunctionName,
            10,
        );

        await createStudySession(
            client,
            edgeFunctionName,
            10,
        );

        // Validate user XP and level
        const { data: userData, error: fetchErrorUsers } = await client
            .from("users")
            .select("*")
            .eq("id", user.id)
            .single();

        assertEquals(fetchErrorUsers, null);
        assertExists(userData);
        assertEquals(userData.level, 4);
        assertEquals(userData.xp, 20);

        // Fetch challenge progress joined with challenge info
        const { data: challenges, error: fetchErrorChallenges } = await client
            .from("challenge_progress")
            .select("*, challenge_id(id, category, difficulty)")
            .eq("user_id", user.id);

        assertEquals(fetchErrorChallenges, null);
        assertExists(challenges);

        // Filter total_sessions only
        const total = challenges
            .filter((c) => c.challenge_id.category === "total_sessions")
            .sort((a, b) =>
                a.challenge_id.difficulty - b.challenge_id.difficulty
            );

        assertEquals(total.length, 2); // one completed, one unlocked
        assertEquals(total[0].completed, true);
        assertEquals(total[1].completed, false);
        assertEquals(total[1].progress, 5);
    });
});

Deno.test("Total Hours Challenge is completed and next one unlocked", async () => {
    await withAnonymousTestUser(async (client, user) => {
        const { sessionData, data, error } = await createStudySession(
            client,
            edgeFunctionName,
            70,
        );

        assertEquals(error, null);
        assertEquals(data, "Sucess");

        // Validate user XP and level
        const { data: userData, error: fetchErrorUsers } = await client
            .from("users")
            .select("*")
            .eq("id", user.id)
            .single();

        assertEquals(fetchErrorUsers, null);
        assertExists(userData);
        assertEquals(userData.level, 4);
        assertEquals(userData.xp, 0);

        // Fetch challenge progress joined with challenge info
        const { data: challenges, error: fetchErrorChallenges } = await client
            .from("challenge_progress")
            .select("*, challenge_id(id, category, difficulty)")
            .eq("user_id", user.id);

        assertEquals(fetchErrorChallenges, null);
        assertExists(challenges);

        // Filter daily_sessions only
        const daily = challenges
            .filter((c) => c.challenge_id.category === "total_hours")
            .sort((a, b) =>
                a.challenge_id.difficulty - b.challenge_id.difficulty
            );

        assertEquals(daily.length, 2); // one completed, one unlocked
        assertEquals(daily[0].completed, true);
        assertEquals(daily[1].completed, false);
        assertEquals(daily[1].progress, 70);
    });
});

Deno.test("Streak Days Challenge is completed and next one unlocked", async () => {
    await withAnonymousTestUser(async (client, user) => {
        const serviceClient = getTestServiceClient();

        // Create a streak_day = 1 entry for yesterday
        const today = new Date();
        const yesterday = new Date(today);
        yesterday.setDate(today.getDate() - 1);

        const yesterdayStr = yesterday.toISOString().slice(0, 10);

        const insertError = await serviceClient
            .from("study_days")
            .insert({
                user_id: user.id,
                study_date: yesterdayStr,
                total_study_time: 25,
                total_study_sessions: 1,
                streak_day: 2,
            });

        if (insertError.error) {
            console.error(
                "Error inserting yesterday streak:",
                insertError.error,
            );
            throw insertError.error;
        }

        // Create a new session for today
        const { sessionData, data, error } = await createStudySession(
            client,
            edgeFunctionName,
            10,
        );

        assertEquals(error, null);
        assertEquals(data, "Sucess");

        // Validate user state
        const { data: userData, error: userFetchError } = await client
            .from("users")
            .select("*")
            .eq("id", user.id)
            .single();

        assertEquals(userFetchError, null);
        assertExists(userData);
        assertEquals(userData.level, 2);
        assertEquals(userData.xp, 10);

        // Fetch challenge progress joined with challenge info
        const { data: challenges, error: fetchErrorChallenges } = await client
            .from("challenge_progress")
            .select("*, challenge_id(id, category, difficulty)")
            .eq("user_id", user.id);

        assertEquals(fetchErrorChallenges, null);
        assertExists(challenges);

        // Filter streak_days only
        const streak = challenges
            .filter((c) => c.challenge_id.category === "streak_days")
            .sort((a, b) =>
                a.challenge_id.difficulty - b.challenge_id.difficulty
            );

        assertEquals(streak.length, 2); // one completed, one unlocked
        assertEquals(streak[0].completed, true);
        assertEquals(streak[1].completed, false);
        assertEquals(streak[1].progress, 3); // streak_day is now 2
    });
});

Deno.test("Max Level is handled correctly", async () => {
    await withAnonymousTestUser(async (client, user) => {
        const serviceClient = getTestServiceClient();

        const updateError = await serviceClient
            .from("users")
            .update({
                level: 10,
                xp: 60,
            })
            .eq("id", user.id);

        if (updateError.error) {
            console.error(
                "Error update user level:",
                updateError.error,
            );
            throw updateError.error;
        }

        // Create a new session for today
        const { sessionData, data, error } = await createStudySession(
            client,
            edgeFunctionName,
            10,
        );

        assertEquals(error, null);
        assertEquals(data, "Sucess");

        // Validate user state
        const { data: userData, error: userFetchError } = await client
            .from("users")
            .select("*")
            .eq("id", user.id)
            .single();

        assertEquals(userFetchError, null);
        assertExists(userData);
        assertEquals(userData.level, 10);
        assertEquals(userData.xp, 80);
    });
});
