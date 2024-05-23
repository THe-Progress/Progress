import requests

# Localhost URL for your Flask server
base_url = "http://127.0.0.1:5000"

# Example request to get a satirical notification
satirical_data = {
    'task': 'Finish report',
    'app': 'YouTube',
    'severity': 1
}

response = requests.post(f"{base_url}/satirical_notification", json=satirical_data)
if response.status_code == 200:
    print("Satirical Notification:", response.json()['message'])
else:
    print("Failed to get satirical notification:", response.text)

# Example request to get an encouraging message
# encouraging_data = {
#     'task': 'Finish report'
# }

# response = requests.post(f"{base_url}/encouraging_message", json=encouraging_data)
# if response.status_code == 200:
#     print("Encouraging Message:", response.json()['message'])
# else:
#     print("Failed to get encouraging message:", response.text)
