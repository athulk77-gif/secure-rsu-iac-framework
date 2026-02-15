import json
import ssl
import time
import signal
import sys
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

PUBLISH_INTERVAL = 2  # seconds between messages
# ==========================================

running = True

def signal_handler(sig, frame):
    global running
    print("\n🛑 Ctrl+C detected. Stopping telemetry...")
    running = False

signal.signal(signal.SIGINT, signal_handler)

def on_connect(client, userdata, flags, rc, properties=None):
    if rc == 0:
        print("✅ Connected successfully to AWS IoT Core")
    else:
        print(f"❌ Connection failed with code {rc}")
        sys.exit(1)

def on_disconnect(client, userdata, rc):
    print("🔌 Disconnected")

def main():
    client = mqtt.Client(client_id=CLIENT_ID, protocol=mqtt.MQTTv311)
    client.on_connect = on_connect
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
    client.loop_start()

    message_id = 0
    while running:
        payload = {
            "rsu_id": "RSU-001",
            "speed": randint(40, 100),
            "lane": randint(1, 3),
            "timestamp": int(time.time())
        }
        message_id += 1
        client.publish(TOPIC, json.dumps(payload), qos=1)
        print(f"📡 Sent ({message_id}):", payload)
        time.sleep(PUBLISH_INTERVAL)

    # Graceful shutdown
    print("🔌 Disconnecting from AWS IoT Core...")
    client.loop_stop()
    client.disconnect()
    print("✅ Telemetry stopped cleanly.")

if __name__ == "__main__":
    main()
