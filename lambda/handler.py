import json
import os
import boto3
import time

ddb = boto3.resource("dynamodb")
table = ddb.Table(os.environ["TABLE_NAME"])


def main(event, context):

    print("📥 Received event:", json.dumps(event))

    try:
        rsu_id = str(event["rsu_id"])
        speed = int(event["speed"])
        lane = int(event.get("lane", 0))
        timestamp = int(event.get("timestamp", int(time.time())))

        item = {
            "rsu_id": rsu_id,
            "timestamp": timestamp,   # 🔑 sort key
            "speed": speed,
            "lane": lane
        }

        table.put_item(Item=item)

        print("✅ PutItem success:", item)

        return {
            "statusCode": 200,
            "body": "Item stored successfully"
        }

    except Exception as e:
        print("❌ ERROR:", str(e))
        raise e
