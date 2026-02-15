# RSU Vehicle Telemetry Simulator

Python MQTT publisher that simulates vehicle telemetry
to AWS IoT Core using device certificate authentication.

Used for thesis RSU security framework testbed demo.

Flow:
Vehicle → IoT Core → Lambda → DynamoDB

Run:
python publish.py
or
python publish-new.py