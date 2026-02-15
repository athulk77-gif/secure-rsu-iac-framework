import json
import ssl
import time
from random import randint
import paho.mqtt.client as mqtt

# ================= CONFIG =================
ENDPOINT = "a7o7on68whyd4-ats.iot.ap-south-1.amazonaws.com"
CLIENT_ID = "vehicle-sim-1"
TOPIC = "rsu/telemetry"

CERT = "device.pem.crt"
KEY = "private.pem.key"
ROOT_CA = "AmazonRootCA1.pem"
PORT = 8883

MAX_MESSAGES = 5  # Number of messages to send
PUBLISH_INTERVAL = 2  # Seconds between messages
# ==========================================

message_count = 0

def on_connect(client, userdata, flags, rc, properties=None):
    if rc == 0:
        print("✅ Connected successfully to AWS IoT Core")
    else:
        print(f"❌ Connection failed with code {rc}")

def on_publish(client, userdata, mid):
    global message_count
    message_count += 1
    if message_count >= MAX_MESSAGES:
        print("🔌 Sent all messages. Disconnecting...")
        client.disconnect()

def on_disconnect(client, userdata, rc):
    print("🔌 Disconnected")

def main():
    client = mqtt.Client(client_id=CLIENT_ID, protocol=mqtt.MQTTv311)
    client.on_connect = on_connect
    client.on_publish = on_publish
    client.on_disconnect = on_disconnect

    client.tls_set(
        ca_certs=ROOT_CA,
        certfile=CERT,
        keyfile=KEY,
        tls_version=ssl.PROTOCOL_TLSv1_2
    )
    client.tls_insecure_set(False)

    print("🔄 Connecting to AWS IoT Core...")
    client.connect(ENDPOINT, PORT, keepalive=60)

    # Start network loop in background
    client.loop_start()

    # Publish messages at interval
    for _ in range(MAX_MESSAGES):
        payload = {
            "rsu_id": "RSU-001",
            "speed": randint(40, 100),
            "lane": randint(1, 3),
            "timestamp": int(time.time())
        }
        client.publish(TOPIC, json.dumps(payload), qos=1)
        print("📡 Sent:", payload)
        time.sleep(PUBLISH_INTERVAL)

    # Wait for disconnect callback
    while client.is_connected():
        time.sleep(0.1)

    client.loop_stop()
    print("✅ Finished successfully")

if __name__ == "__main__":
    main()
