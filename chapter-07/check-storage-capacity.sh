#!/bin/bash
#=============================================================================
# The Oracle's Warning - Storage Capacity Sentinel V1
#=============================================================================
# Checks the usage of a specified filesystem and sends an alert
# if it exceeds a critical threshold.
#===========================================================
# --- CONFIGURATION ---
# The threshold (as a percentage) at which to trigger the alarm. 85 is a sane default.
THRESHOLD=85
# The filesystem to monitor. Use `df -h` on your NAS to find the correct path.
FILESYSTEM_TO_WATCH="/volume1"


# --- SCRIPT LOGIC ---
# Get the current usage percentage for the specified filesystem.
# This command is a standard sysadmin's weapon.
CURRENT_USAGE=$(df -P "$FILESYSTEM_TO_WATCH" | awk 'NR==2 {print $5}' | sed 's/%//')


# Compare the current usage with our threshold.
if [ "$CURRENT_USAGE" -ge "$THRESHOLD" ]; then
  echo "CRITICAL: Filesystem $FILESYSTEM_TO_WATCH is at $CURRENT_USAGE% capacity! The fortress is running out of space!"
  # Add your alert command here (e.g., mail, pushover, etc.)
Fi
