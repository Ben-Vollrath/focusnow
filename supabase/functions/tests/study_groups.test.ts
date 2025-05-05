import {
    assertEquals,
    assertNotEquals,
} from "https://deno.land/std@0.192.0/testing/asserts.ts";
import { getTestServiceClient, withAnonymousTestUser } from "./test-utils.ts";

Deno.test("RLS blocks access to private study group from base table", async () => {
    await withAnonymousTestUser(async (creatorClient) => {
        const groupName = "Private Group " + crypto.randomUUID();

        const { error: rpcError } = await creatorClient.rpc(
            "create_study_group",
            {
                group_name: groupName,
                group_description: "Hidden",
                is_public: false,
            },
        );

        if (rpcError) throw rpcError;

        await withAnonymousTestUser(async (otherClient) => {
            const { data, error } = await otherClient
                .from("study_groups")
                .select("*")
                .eq("name", groupName);

            assertEquals(error, null);
            assertEquals(data, []); // ✅ RLS is enforced here
        });
    });
});

Deno.test("RLS is enforced on study_group_stats view", async () => {
    await withAnonymousTestUser(async (creatorClient) => {
        const groupName = "Private Group";

        const { error: rpcError } = await creatorClient.rpc(
            "create_study_group",
            {
                group_name: groupName,
                group_description: "Hidden via view",
                is_public: false,
            },
        );
        const { data, error } = await creatorClient
            .from("study_group_stats")
            .select("*")
            .eq("name", groupName);

        console.log("Data:", data);
        assertNotEquals(data, null);
        if (rpcError) throw rpcError;

        await withAnonymousTestUser(async (otherClient) => {
            const { data, error } = await otherClient
                .from("study_group_stats")
                .select("*")
                .eq("name", groupName);

            console.log("Data:", data);
            assertEquals(error, null);
            assertEquals(
                data,
                [],
            );
        });
    });
});
