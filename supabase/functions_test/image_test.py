import os
from supabase import create_client, Client
import requests
from dotenv import load_dotenv

# Replace with your actual Supabase URL and anon key
supabase_url = "http://127.0.0.1:54321"
# Get Supabase anon key from .env file
load_dotenv()
supabase_anon_key = os.getenv("SUPABASE_ANON_KEY")

# Initialize the Supabase client
supabase: Client = create_client(supabase_url, supabase_anon_key)

# User credentials
email = "test@test.com"
password = "securepassword"

def sign_in_and_get_jwt():
    response = supabase.auth.sign_in_with_password(credentials={"email": email, "password": password})
    

    user = response.user
    session = response.session
    jwt_token = session.access_token
    #print("User signed in:", user)
    #print("JWT Token:", jwt_token)
    return jwt_token

# Obtain JWT token
jwt_token = sign_in_and_get_jwt()

if jwt_token:
    # Define the endpoint URL
    url = "http://127.0.0.1:54321/functions/v1/generate-image"

    # Define the payload
    payload = {
        "description": "A beautiful sunset over the mountains",
        "style": "impressionist"
    }

    # Define the headers
    headers = {
        "Authorization": f"Bearer {jwt_token}",
        "Content-Type": "application/json"
    }

    # Send the POST request
    response = requests.post(url, json=payload, headers=headers)

    # Print the response
    print("Status Code:", response.status_code)
    print("Response Body:", response.json())
else:
    print("Failed to obtain JWT token")