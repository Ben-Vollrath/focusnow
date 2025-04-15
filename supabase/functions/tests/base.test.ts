// testClientCreation.test.ts
import {
  assert,
  assertEquals,
  assertExists,
} from "https://deno.land/std@0.192.0/testing/asserts.ts";
import { getTestClient, withAnonymousTestUser } from "./test-utils.ts";

Deno.test("Client Creation Test", async () => {
  const client = getTestClient();

  const { data, error } = await client.from("users").select("*").limit(1);
  if (error) {
    throw new Error("Query failed: " + error.message);
  }

  assert(data, "Expected data to be returned from the users table.");
});

Deno.test("createAnonymousTestUser returns a valid authed client and user", async () => {
  await withAnonymousTestUser(async (client, user) => {
    // User ID should exist
    assertExists(user.id, "User ID should be returned");

    // Make a simple authed query to confirm the session works
    const { error } = await client.from("study_sessions").select("*").limit(1);
    assertEquals(error, null, "Authed client should be able to query tables");

    // Optional: print info for debugging
    console.log("Anonymous user created with ID:", user.id);
  });
});
