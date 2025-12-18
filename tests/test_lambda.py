import os
import boto3
import pytest
from moto import mock_aws 
import json

# We must set these BEFORE importing backend.py
# Boto3 checks these exist during import, even if we are mocking.

os.environ["AWS_ACCESS_KEY_ID"] = "testing"
os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
os.environ["AWS_SECURITY_TOKEN"] = "testing"
os.environ["AWS_SESSION_TOKEN"] = "testing"
os.environ["AWS_DEFAULT_REGION"] = "ap-south-1"
os.environ["TABLE_NAME"] = "test-table"


import backend

@mock_aws
def test_lambda_handler_updates_count():
    # 1. Setup Mock DynamoDB
    dynamodb = boto3.resource("dynamodb", region_name="ap-south-1")
    
    table = dynamodb.create_table(
        TableName="test-table",
        KeySchema=[{"AttributeName": "pk", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "pk", "AttributeType": "S"}],
        ProvisionedThroughput={"ReadCapacityUnits": 1, "WriteCapacityUnits": 1}
    )
    
    # 2. Run the Lambda
    # The lambda function uses the global 'table' resource created during import,
    # but under @mock_aws, requests are intercepted.
    response = backend.lambda_handler({}, {})

    # 3. Verify
    body = json.loads(response["body"])
    assert response["statusCode"] == 200
    assert body["count"] == 1