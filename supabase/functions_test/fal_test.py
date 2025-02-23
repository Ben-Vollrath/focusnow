import os
import time
import requests

# Environment Variables (replace with your actual keys or set them in your environment)
FAL_API_KEY = "f8b12fb5-0cfc-42eb-afc6-837cd6c229dd:ed90a3e3a7ee421fb4951ffb91ab8215"

# API URLs
SUBMIT_URL = "https://queue.fal.run/fal-ai/flux/schnell"
STATUS_URL_TEMPLATE = "https://queue.fal.run/fal-ai/flux/requests/{request_id}/status"

# Prompt for the image generation
PROMPT = "Extreme close-up of a single tiger eye, direct frontal view. Detailed iris and pupil. Sharp focus on eye texture and color. Natural lighting to capture authentic eye shine and depth."

# Function to continuously check the status
def create_image_and_check_status():
    headers = {
        "Authorization": f"Key {FAL_API_KEY}",
        "Content-Type": "application/json",
    }
    
    # Submit the image generation request
    response = requests.post(SUBMIT_URL, headers=headers, json={"prompt": PROMPT})
    if response.status_code != 200:
        print("Failed to submit request:", response.text)
        return
    
    request_data = response.json()
    request_id = request_data.get("request_id")
    if not request_id:
        print("No request_id found in response:", request_data)
        return
    
    print(f"Request submitted. Request ID: {request_id}")
    
    # Continuously fetch the status of the request
    status_url = STATUS_URL_TEMPLATE.format(request_id=request_id)
    try:
        while True:
            status_response = requests.get(status_url, headers=headers)
            
            status_data = status_response.json()
            print("Status response data:", status_data)

            # Wait for a few seconds before the next check
            time.sleep(5)
    except KeyboardInterrupt:
        print("Stopped checking the status manually.")

# Run the function
create_image_and_check_status()
