#!/bin/bash
# This script checks the SMART health of all physical disks using lsblk.
command -v smartctl >/dev/null 2>&1 || { echo "FATAL: smartmontools is not installed."; exit 1; }


for disk in $(lsblk -d -o NAME,TYPE | grep 'disk' | awk '{print $1}'); do
  DEVICE="/dev/$disk"
  status=$(smartctl -H "$DEVICE" | grep "SMART overall-health")
  if [[ ! "$status" =~ "PASSED" && ! "$status" =~ "OK" ]]; then
    echo "CRITICAL: SMART health check FAILED for disk $DEVICE!"
  Fi
done
