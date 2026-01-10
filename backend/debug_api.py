
import requests
import json

try:
    response = requests.get("http://127.0.0.1:8000/drops")
    print(f"Status: {response.status_code}")
    if response.status_code != 200:
        print(response.text)
    else:
        print("Success")
        # print(json.dumps(response.json(), indent=2))
except Exception as e:
    print(f"Error: {e}")
