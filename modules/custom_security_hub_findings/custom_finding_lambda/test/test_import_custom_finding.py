import json
from unittest import mock
import pytest

from src.findings.import_security_hub_finding import lambda_handler
from .test_fixtures import os_environment_setup


class TestImportSecurityHubFinding:

    @mock.patch("boto3.client")
    def test_iam_user_creation_event(self, mock_client, os_environment_setup):
        event = json.load(open("./test/iam_user_creation_template.json"))
        assert lambda_handler(event, {}) == {
            'statusCode': 200
        }

    @mock.patch("boto3.client")
    def test_wrong_message_exception_for_security_hub_import_finding(self, mock_client, os_environment_setup):
        invalid_json = {}
        with pytest.raises(KeyError):
            lambda_handler(invalid_json, {})
