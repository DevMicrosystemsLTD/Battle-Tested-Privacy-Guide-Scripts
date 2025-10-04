#!/bin/bash

#=============================================================================
# The Syncthing Heartbeat Monitor V2 (Battle-Tested)
#=============================================================================
# This script uses the Syncthing API to check if a specific device is
# online and connected.
#=============================================================================

# --- CONFIGURATION ---
# IMPORTANT: Find your API Key in Syncthing's Web GUI under: Actions > Settings > General
SYNCTHING_API_KEY="YOUR_API_KEY_HERE"
SYNCTHING_URL="http://127.0.0.1:8384"
# IMPORTANT: Find the Device ID you want to monitor in Syncthing's Web GUI.
EXPECTED_DEVICE_ID="DEVICE_ID_OF_YOUR_LAPTOP_HERE"
# The log file will be created in a 'logs' folder inside your home directory.
LOG_FILE="$HOME/logs/syncthing_heartbeat.log"

# --- BATTLE-TESTED PRE-FLIGHT CHECK ---
# Check if our required weapons (curl and jq) are installed.
command -v curl >/dev/null 2>&1 || { echo "FATAL ERROR: curl is not installed. Aborting." >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "FATAL ERROR: jq is not installed. Aborting." >&2; exit 1; }

# --- SCRIPT LOGIC ---
# Create a log file directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Use curl to get connection data from the API, and jq to parse it
connections=$(curl -s -H "X-API-Key: $SYNCTHING_API_KEY" "$SYNCTHING_URL/rest/system/connections")
device_status=$(echo "$connections" | jq -r ".connections[\"$EXPECTED_DEVICE_ID\"].connected")

if [ "$device_status" != "true" ]; then
    echo "$(date): WARNING - Device $EXPECTED_DEVICE_ID is offline!" >> "$LOG_FILE"
    # Add your alert command here (e.g., mail, pushover, etc.)
else
    echo "$(date): SUCCESS - Device $EXPECTED_DEVICE_ID is connected." >> "$LOG_FILE"
fi
