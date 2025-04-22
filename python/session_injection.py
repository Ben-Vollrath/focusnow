import os
import requests
from datetime import datetime, timedelta, timezone
from dotenv import load_dotenv
from supabase import create_client, Client

# --- Load env vars ---
load_dotenv()
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_ANON_KEY = os.getenv("SUPABASE_ANON_KEY")
SUPABASE_EMAIL = os.getenv("EMAIL")
SUPABASE_PASSWORD = os.getenv("PASSWORD")
EDGE_FUNCTION_URL = f"{SUPABASE_URL}/functions/v1/handle-completed-study-session"

# --- Init Supabase client ---
supabase: Client = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)

# --- Sign in with email + password ---
session = supabase.auth.sign_in_with_password({
    "email": SUPABASE_EMAIL,
    "password": SUPABASE_PASSWORD
})
access_token = session.session.access_token
print(f"✅ Logged in as {SUPABASE_EMAIL[:3]}***")

# --- Generate study session data ---
def generate_study_session(start_time: datetime, duration_minutes: int) -> dict:
    end_time = start_time + timedelta(minutes=duration_minutes)
    return {
        "start_time": start_time.isoformat(),
        "end_time": end_time.isoformat(),
    }

# --- Create multiple sessions ---
num_sessions = 4
duration_minutes = 25
base_start_time = datetime.now(timezone.utc) - timedelta(minutes=num_sessions * duration_minutes)

headers = {
    "Authorization": f"Bearer {access_token}",
    "Content-Type": "application/json"
}

for i in range(num_sessions):
    session_start = base_start_time + timedelta(minutes=i * duration_minutes)
    data = generate_study_session(session_start, duration_minutes)
    response = requests.post(EDGE_FUNCTION_URL, json=data, headers=headers)
    print(f"📚 Session {i+1}: {response.status_code} - {response.text}")
