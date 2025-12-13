import os
import json
import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.resource("dynamodb")
TABLE_NAME = os.environ.get("TABLE_NAME", "CountTable")
PK_NAME = os.environ.get("PK_NAME", "counter_id")   # "counterId"
COUNTER_KEY = os.environ.get("COUNTER_KEY", "visitors")  # primary key value

table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    try:
        # Atomic increment: if attribute 'count' doesn't exist, start at 0 then add 1
        resp = table.update_item(
            Key={PK_NAME: COUNTER_KEY},
            UpdateExpression="SET #c = if_not_exists(#c, :start) + :inc",
            ExpressionAttributeNames={"#c": "count"},
            ExpressionAttributeValues={":inc": 1, ":start": 0},
            ReturnValues="UPDATED_NEW"
        )
        new_count = int(resp["Attributes"]["count"])
    except ClientError as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "dynamodb update failed", "message": str(e)})
        }

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"    
        },
        "body": json.dumps({"count": new_count})
    }
