import { create } from "https://deno.land/x/djwt@v2.7/mod.ts";
import { createClient } from 'jsr:@supabase/supabase-js@2'

async function importPrivateKey(pemKey: string): Promise<CryptoKey> {
  // Remove PEM formatting
  const pemHeader = "-----BEGIN PRIVATE KEY-----";
  const pemFooter = "-----END PRIVATE KEY-----";
  const pemContents = pemKey.replace(pemHeader, "").replace(pemFooter, "").replace(/\s+/g, "");
  
  // Decode base64 PEM key
  const binaryKey = Uint8Array.from(atob(pemContents), (char) => char.charCodeAt(0));

  // Import the key as a CryptoKey
  return await crypto.subtle.importKey(
    "pkcs8", // Key format
    binaryKey.buffer, // Key data
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" }, // Algorithm
    false, // Not extractable
    ["sign"] // Usages
  );
}

const serviceAccountKey = JSON.parse(Deno.env.get("GOOGLE_API_SERVICE_KEY") || "{}");
const supabaseUrl = Deno.env.get('SUPABASE_URL') || ''
const supabaseServiceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || ''
const supabaseClient = createClient(supabaseUrl, supabaseServiceRoleKey)

Deno.serve(async (req) => {
  try {
    const { productId, purchaseToken } = await req.json();

    if (!productId || !purchaseToken) {
      return new Response(
        JSON.stringify({ error: "Missing productId or purchaseToken" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    

    if (!serviceAccountKey.private_key) {
      throw new Error("Service account private key is missing or malformed.");
    }

    const privateKey = serviceAccountKey.private_key;
    const cryptoKey = await importPrivateKey(privateKey);

    console.log("Creating JWT for Google API authentication");

    const now = Math.floor(Date.now() / 1000);
    const payload = {
      iss: serviceAccountKey.client_email,
      scope: "https://www.googleapis.com/auth/androidpublisher",
      aud: "https://oauth2.googleapis.com/token",
      iat: now,
      exp: now + 3600, // Token valid for 1 hour
    };

    const jwt = await create(
      { alg: "RS256", typ: "JWT" },
      payload,
      cryptoKey
    );

    console.log("JWT created successfully");

    // Exchange JWT for Access Token
    const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
        assertion: jwt,
      }),
    });

    if (!tokenResponse.ok) {
      const error = await tokenResponse.json();
      throw new Error("Failed to get access token: " + error.error_description);
    }

    const { access_token } = await tokenResponse.json();
    console.log("Access token obtained");

    // Validate the purchase
    const packageName = "io.vollrath.focusnow";
    const url = `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/subscriptions/${productId}/tokens/${purchaseToken}`;
    const apiResponse = await fetch(url, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${access_token}`,
        "Content-Type": "application/json",
      },
    });

    if (!apiResponse.ok) {
      const error = await apiResponse.json();
      return new Response(
        JSON.stringify({ success: false, error }),
        { status: apiResponse.status, headers: { "Content-Type": "application/json" } }
      );
    }

    const responseData = await apiResponse.json();
    console.log(responseData);
    const paymentState = responseData.paymentState; // 0: Pending, 1: Received, 2: Free trial, 3: Cancelled
    const isAcknowledged = responseData.acknowledgementState === 1; // 1: Acknowledged

    if (paymentState === 1 && isAcknowledged) {
      return new Response(
        JSON.stringify({ success: true, message: "Purchase is valid and acknowledged" }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    } else if (paymentState === 1 && !isAcknowledged) {
      // Give user subscription benefits and acknowledge the purchase
      const authHeader = req.headers.get('Authorization')?.replace('Bearer ', '')
      if (!authHeader) throw new Error('Authorization header missing')

      const { data: userData, error: userError } = await supabaseClient.auth.getUser(authHeader)
      if (userError) throw new Error(userError.message)
  
      const userId = userData.user.id

      const response = await supabaseClient.rpc('purchased_subscription', { 
        p_expiration_date:responseData.expiryTimeMillis, 
        p_order_id: responseData.orderId, 
        p_purchase_date: responseData.startTimeMillis, 
        p_purchase_token: purchaseToken, 
        p_user_id: userId
      })

      console.log(response)

      return new Response(
        JSON.stringify({ success: true, message: "Purchase is valid but not acknowledged" }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    } else {
      return new Response(
        JSON.stringify({ success: false, message: "Purchase is not valid" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }
  } catch (error) {
    console.error(error);
    return new Response(
      JSON.stringify({ error: "Failed to validate purchase", details: error.message }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});
