import google.auth
from google.auth.transport.requests import AuthorizedSession
from requests.exceptions import HTTPError
import os

credentials, project = google.auth.default(scopes=['openid', 'email', 'profile'])

base_url = os.environ["API_URL"]
dataset_id = os.environ["DATASET_ID"]
target_path = os.environ["TARGET_PATH"]

authed_session = AuthorizedSession(credentials)

def get_file_id(target_path: str):
    response = authed_session.get(f"{base_url}/api/repository/v1/datasets/{dataset_id}/filesystem/objects",
                                  params={"path": target_path})
    if response.status_code == 200:
        return response.json()["fileId"]
    elif response.status_code != 404:
        raise HTTPError(f"Unexpected response, got code of: {response.status_code}")

file_id = get_file_id(target_path)
if file_id:
    print(file_id)
else:
    print("null")
