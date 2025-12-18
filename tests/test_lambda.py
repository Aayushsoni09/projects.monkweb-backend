import boto3
import pytest
from moto import mock_aws
import os
import json

# Set dummy env vars
os.environ["TABLE_NAME"] = "test-table"

# 1. IMPORT YOUR ACTUAL FILENAME
import ../backend 

@mock_aws
def test_lambda_handler_updates_count():
    # Setup Mock DynamoDB
    dynamodb = boto3.resource("dynamodb", region_name="us-east-1")
    table = dynamodb.create_table(
        TableName="test-table",
        KeySchema=[{"AttributeName": "pk", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "pk", "AttributeType": "S"}],
        ProvisionedThroughput={"ReadCapacityUnits": 1, "WriteCapacityUnits": 1}
    )
    
    # 2. CALL THE FUNCTION FROM 'backend'
    response = backend.lambda_handler({}, {})

    # Verify Response
    body = json.loads(response["body"])
    assert response["statusCode"] == 200
    assert "count" in body
    assert body["count"] == 1