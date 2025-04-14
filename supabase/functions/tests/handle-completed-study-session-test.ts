// handleCompletedStudySession.test.ts
import {
    assertEquals,
    assertExists,
} from "https://deno.land/std@0.192.0/testing/asserts.ts";
import { createAnonymousTestUser, createStudySession } from "./test-utils.ts";
import { delay } from "https://deno.land/std@0.192.0/async/delay.ts";

const edgeFunctionName = "handle-completed-study-session";

Deno.test("Edge function inserts study session for user", async () => {
    const { client, user } = await createAnonymousTestUser();

    const now = new Date();
    const sessionData = {
        sessionDate: now.toISOString().split("T")[0],
        start_time: now.toISOString(),
        end_time: new Date(now.getTime() + 25 * 60_000).toISOString(),
    };

    const { data: funcData, error: funcError } = await client.functions.invoke(
        edgeFunctionName,
        {
            body: sessionData,
        },
    );

    assertEquals(funcError, null);
    assertEquals(funcData, "Sucess");

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

Deno.test("Edge function inserts study days for user", async () => {
    const { client, user } = await createAnonymousTestUser();

    const { sessionData, data, error } = await createStudySession(
        client,
        edgeFunctionName,
    );

    assertEquals(error, null);
    assertEquals(data, "Sucess");

    await delay(1000);

    const { data: study_days, error: fetchError } = await client
        .from("study_days")
        .select("*")
        .limit(1);

    assertEquals(fetchError, null);
    assertExists(study_days?.[0]);
    assertEquals(study_days?.[0].user_id, user.id);
    assertEquals(study_days?.[0].study_date, sessionData.sessionDate);
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
    assertEquals(study_days2?.[0].study_date, sessionData.sessionDate);
    assertEquals(study_days2?.[0].total_study_time, 50);
});

Deno.test("Goal is updated", async () => {
    const { client, user } = await createAnonymousTestUser();

    //Add a goal for the user
    const goalData = {
        target_minutes: 60,
        target_date: new Date(Date.now() + 7 * 24 * 60 * 60_000) // 1 week from now
            .toISOString()
            .split("T")[0],
    };

    const { data, error } = await client.functions.invoke("create-goal", {
        body: goalData,
    });

    const now = new Date();
    const sessionData = {
        sessionDate: now.toISOString().split("T")[0],
        start_time: now.toISOString(),
        end_time: new Date(now.getTime() + 25 * 60_000).toISOString(),
    };

    const { data: funcData, error: funcError } = await client.functions.invoke(
        edgeFunctionName,
        {
            body: sessionData,
        },
    );

    assertEquals(funcError, null);
    assertEquals(funcData, "Sucess");

    await delay(100);

    const { data: goal, error: fetchError } = await client
        .from("goals")
        .select("*")
        .limit(1);

    assertEquals(fetchError, null);
    assertExists(goal?.[0]);
    assertEquals(goal?.[0].user_id, user.id);
    assertEquals(goal?.[0].current_minutes, 25);
});
