from unittest.mock import patch
import importlib

ingest_file_module = importlib.import_module("submit-file-ingest")


@patch("requests.post")
def test_ingest_file(mock_post):
    ingest_file_module.ingest_file(mock_post, "http://example.com", "example_dataset_id", profile_id="fake_profile_id",
                                   source_path="gs://fake_source_path", target_path="/fake_target_path")

    mock_post.post.assert_called_with("http://example.com/api/repository/v1/datasets/example_dataset_id/files",
                                      json={"source_path": "gs://fake_source_path",
                                            "target_path": "/fake_target_path",
                                            "profileId": "fake_profile_id"})
