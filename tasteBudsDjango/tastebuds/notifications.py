import requests

#apns url for sending push notifs to real devices
APNS_URL = "https://api.push.apple.com/3/device/"

#placeholder until we have apple dev account
authtoken = "tastebuds_auth_token"

def send_push_notification(device_token, message):
    url = f"{APNS_URL}{device_token}"

    headers = {
        "Authorization": f"Bearer {authtoken}",
        "Content-Type": "application/json"
    }
    payload = {
        "aps": {
            "alert": message,
            "sound": "default"
        }
    }

    response = requests.post(url, headers=headers, json=payload)

    if response.status_code == 200:
        print("Push notification sent successfully")
    else:
        print(f"Error sending notification: {response.status_code} - {response.text}")