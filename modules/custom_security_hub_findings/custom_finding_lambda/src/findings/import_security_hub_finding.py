import boto3

from .iam_user_creation_finding import IamUserCreationFinding


def lambda_handler(event, context):
    try:
        response = {}
        if event['source'] == "aws.iam":
            response = boto3.client('securityhub').batch_import_findings(Findings=IamUserCreationFinding(event).create_notification())
        else:
            pass
        return {
            'statusCode': 200
        }
    except Exception as e:
        print(e)
        raise
