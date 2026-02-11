import json
import os
import boto3
from datetime import datetime

ddb = boto3.resource("dynamodb")
table = ddb.Table(os.environ["TABLE_NAME"])


def main(event, context):

    rsu_id = event.get("rsu_id", "rsu-1")
    speed = event.get("speed", 0)

    item = {
        "rsu_id": rsu_id,
        "last_speed": speed,
        "timestamp": datetime.utcnow().isoformat()
    }

    table.put_item(Item=item)

    return {
        "status": "ok",
        "rsu": rsu_id
    }
