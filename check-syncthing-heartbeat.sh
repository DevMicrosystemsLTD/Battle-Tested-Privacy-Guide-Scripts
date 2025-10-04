#!/bin/bash

# --- CONFIGURATION ---
SYNCTHING_API_KEY="YOUR_API_KEY_HERE"
SYNCTHING_URL="http://127.0.0.1:8384"
EXPECTED_DEVICE_ID="DEVICE_ID_OF_YOUR_LAPTOP_HERE"
LOG_FILE="/var/log/syncthing_heartbeat.log"

# --- SCRIPT LOGIC ---
# Use curl to get connection data from the API, and jq to parse it
connections=$(curl -s -H "X-API-Key: $SYNCTHING_API_KEY" "$SYNCTHING_URL/rest/system/connections")
device_status=$(echo "$connections" | jq -r ".connections[\"$EXPECTED_DEVICE_ID\"].connected")

if [ "$device_status" != "true" ]; then
    echo "$(date): WARNING - Device $EXPECTED_DEVICE_ID is offline!" >> "$LOG_FILE"
    # Add your alert command here (e.g., mail, pushover, etc.)
else
    echo "$(date): SUCCESS - Device $EXPECTED_DEVICE_ID is connected." >> "$LOG_FILE"
fi
