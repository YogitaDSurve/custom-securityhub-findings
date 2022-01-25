import json
import os
from unittest import mock
import pytest
from freezegun import freeze_time

from src.findings.iam_user_creation_finding import IamUserCreationFinding
from .test_fixtures import os_environment_setup


class TestIamUserCreationFinding:

    @freeze_time("2021-11-25")
    @mock.patch("uuid.uuid4")
    def test_build_finding_for_iam_user_creation(self, mock_uuid, os_environment_setup):
        account_number = os.environ["account_num"]
        region = os.environ["region"]
        mock_uuid.return_value = 'mock-uuid'
        event = json.load(open("./test/iam_user_creation_template.json"))
        finding = IamUserCreationFinding(event)
        finding_message = finding.create_notification()
        expected_datetime = '2021-11-25T00:00:00+00:00'
        assert finding_message == [
            {
                'SchemaVersion': '2018-10-08',
                'Id': "mock-uuid",
                'ProductArn': 'arn:aws:securityhub:' + region + ':' + account_number + ':product/' + account_number + '/default',
                'ProductFields': {'UserAgent': 'console.amazonaws.com'},
                'GeneratorId': "mock-uuid",
                'AwsAccountId': account_number,
                'Types': ['Software and Configuration Checks'],
                'FirstObservedAt': expected_datetime,
                'UpdatedAt': expected_datetime,
                'CreatedAt': expected_datetime,
                'Severity': {'Label': "MEDIUM"},
                'Title': "IAM User Created",
                'Description': "IAM User Created",
                'Resources': [
                    {
                        'Type': 'AwsIAM',
                        'Id': "arn:aws:iam::012345678949:user/test-user",
                        'Partition': 'aws',
                        'Region': region,
                        'Details': {
                            'AwsIamUser': {'CreateDate': expected_datetime, 'Path': '/', 'UserId': "AIEWNKDXYOJCCMRVXWLP4KM",
                                           'UserName': "test-user"}
                        }
                    }
                ],
                'WorkflowState': 'NEW',
                'Compliance': {'Status': "FAILED"},
                'RecordState': 'ACTIVE',
                'Note': {'Text': "AssumedRole",
                         'UpdatedBy': "arn:aws:sts::012345678949:assumed-role/AWSReservedSSO_DevOps_jr12345c84697f04/your_email@domain.com",
                         'UpdatedAt': expected_datetime}
            }
        ]

    # def test_wrong_message_exception_for_iam_user_creation(self):
    #     invalid_json = json.load(open('./test/kinesis_stream_creation_template.json'))
    #     with pytest.raises(TypeError):
    #         IamUserCreationFinding(invalid_json).create_notification()
