import json
import ssl
import time
import signal
import sys
import uuid
from random import randint
import paho.mqtt.client as mqtt

ENDPOINT = "a7o7on68whyd4-ats.iot.ap-south-1.amazonaws.com"
CLIENT_ID = f"vehicle-sim-{uuid.uuid4()}"
TOPIC = "rsu/telemetry"

CERT = "device.pem.crt"
KEY = "private.pem.key"
ROOT_CA = "AmazonRootCA1.pem"
PORT = 8883

PUBLISH_INTERVAL = 2

connected = False
running = True


def signal_handler(sig, frame):
    global running
    print("\n🛑 Ctrl+C detected. Stopping telemetry...")
    running = False


signal.signal(signal.SIGINT, signal_handler)


def on_connect(client, userdata, flags, rc):
    global connected
    if rc == 0:
        connected = True
        print("✅ Connected successfully to AWS IoT Core")
    else:
        print(f"❌ Connection failed with code {rc}")


def on_disconnect(client, userdata, rc):
    global connected
    connected = False
    if rc != 0:
        print("⚠️ Unexpected disconnection.")
    else:
        print("🔌 Disconnected cleanly")


def main():
    client = mqtt.Client(client_id=CLIENT_ID)
    client.on_connect = on_connect
    client.on_disconnect = on_disconnect

    client.tls_set(
        ca_certs=ROOT_CA,
        certfile=CERT,
        keyfile=KEY,
        tls_version=ssl.PROTOCOL_TLSv1_2
    )

    client.reconnect_delay_set(min_delay=1, max_delay=5)

    print("🔄 Connecting to AWS IoT Core...")
    client.connect(ENDPOINT, PORT, keepalive=60)

    client.loop_start()

    # Wait until fully connected
    while not connected:
        time.sleep(0.1)

    print("🚀 Starting telemetry stream...\n")

    message_id = 0

    while running:
        if connected:
            payload = {
                "rsu_id": "RSU-001",
                "speed": randint(40, 100),
                "lane": randint(1, 3),
                "timestamp": int(time.time())
            }

            result = client.publish(TOPIC, json.dumps(payload), qos=1)

            if result.rc == mqtt.MQTT_ERR_SUCCESS:
                message_id += 1
                print(f"📡 Sent ({message_id}):", payload)
            else:
                print("❌ Publish failed")

        time.sleep(PUBLISH_INTERVAL)

    print("\n🔌 Disconnecting from AWS IoT Core...")
    client.loop_stop()
    client.disconnect()
    print("✅ Telemetry stopped cleanly.")


if __name__ == "__main__":
    main()
