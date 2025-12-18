import boto3
import pytest
from moto import mock_aws
import os
import json

# Set dummy env vars for the test
os.environ["TABLE_NAME"] = "test-table"

# Import your lambda code (Assuming your file is named 'counter.py')
import counter 

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
    
    # 2. Run the Lambda Function
    # We pass a dummy event
    response = counter.lambda_handler({}, {})

    # 3. Verify the Response
    body = json.loads(response["body"])
    assert response["statusCode"] == 200
    assert "count" in body
    assert body["count"] == 1 # First visit should be 1