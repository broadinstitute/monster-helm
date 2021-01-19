import google.auth
from google.auth.transport.requests import AuthorizedSession
from requests.exceptions import HTTPError
import os


def ingest_file(session, base_url: str, dataset_id: str, profile_id: str, source_path: str, target_path: str):
    body = {
        "loadArray": [
            {
                "sourcePath": source_path,
                "targetPath": target_path
            }
        ],
        "maxFailedFileLoads": 0,
        "profileId": profile_id
    }
    response = session.post(f"{base_url}/api/repository/v1/datasets/{dataset_id}/files/bulk/array", json=body)
    if response.ok:
        return response.json()["id"]
    else:
        raise HTTPError(f"Bad response, got code of: {response.status_code}")


def authed_session():
    credentials, project = google.auth.default(scopes=['openid', 'email', 'profile'])
    return AuthorizedSession(credentials)


if __name__ == '__main__':
    # print the job id to std out
    result = ingest_file(
        base_url=os.environ["API_URL"],
        dataset_id=os.environ["DATASET_ID"],
        profile_id=os.environ["PROFILE_ID"],
        source_path=os.environ["SOURCE_PATH"],
        target_path=os.environ["TARGET_PATH"]
    )
    print(result)
