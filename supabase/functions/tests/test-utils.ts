// supabaseTestClient.ts
import { createClient, SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { config } from "https://deno.land/x/dotenv@v3.2.2/mod.ts";

// Load .env.test only once
const env = config({ path: ".env.test" });

const supabaseUrl = env.SUPABASE_URL;
const supabaseAnonKey = env.SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error(
        "SUPABASE_URL and SUPABASE_ANON_KEY must be set in .env.test",
    );
}

const options = {
    auth: {
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUrl: false,
    },
};

export function getTestClient(): SupabaseClient {
    return createClient(supabaseUrl, supabaseAnonKey, options);
}

export async function createAnonymousTestUser(): Promise<{
    client: SupabaseClient;
    user: { id: string };
}> {
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

    return {
        client: authedClient,
        user: { id: data.user.id },
    };
}
