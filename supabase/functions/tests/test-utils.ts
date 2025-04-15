// supabaseTestClient.ts
import { createClient, SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { config } from "https://deno.land/x/dotenv@v3.2.2/mod.ts";

// Load .env.test only once
const env = config({ path: ".env.test" });

const supabaseUrl = env.SUPABASE_URL;
const supabaseAnonKey = env.SUPABASE_ANON_KEY;
const supabaseServiceKey = env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseAnonKey || !supabaseServiceKey) {
    throw new Error(
        "SUPABASE_URL and SUPABASE_ANON_KEY and SUPABASE_SERVICE_KEY must be set in .env.tes",
    );
}

const options = {
    auth: {
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUrl: false,
    },
};

export function getTestServiceClient(): SupabaseClient {
    return createClient(supabaseUrl, supabaseServiceKey, options);
}

export function getTestClient(): SupabaseClient {
    return createClient(supabaseUrl, supabaseAnonKey, options);
}

export async function withAnonymousTestUser(
    testFn: (client: SupabaseClient, user: { id: string }) => Promise<void>,
) {
    const { data, error } = await getTestClient().auth.signInAnonymously();

    if (error || !data.session?.access_token || !data.user) {
        throw new Error("Failed to sign in anonymously: " + error?.message);
    }

    const authedClient = createClient(supabaseUrl, supabaseAnonKey, {
        global: {
            headers: {
                Authorization: `Bearer ${data.session.access_token}`,
            },
        },
        auth: {
            autoRefreshToken: false,
            persistSession: false,
            detectSessionInUrl: false,
        },
    });

    try {
        await testFn(authedClient, { id: data.user.id });
    } finally {
        // Delete user using service client
        const serviceClient = getTestServiceClient();
        const { error: deleteError } = await serviceClient.auth.admin
            .deleteUser(data.user.id);
        if (deleteError) {
            console.warn(
                `Failed to delete test user ${data.user.id}:`,
                deleteError.message,
            );
        }
    }
}

export async function createStudySession(
    client: SupabaseClient,
    edgeFunctionName: string,
    durationMinutes = 25,
) {
    const now = new Date();
    const sessionData = {
        start_time: now.toISOString(),
        end_time: new Date(now.getTime() + durationMinutes * 60_000)
            .toISOString(),
    };

    const { data, error } = await client.functions.invoke(edgeFunctionName, {
        body: sessionData,
    });

    return { sessionData, data, error };
}
