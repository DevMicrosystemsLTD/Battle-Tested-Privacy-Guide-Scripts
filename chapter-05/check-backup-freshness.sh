#!/bin/bash
# This script checks if the most recent file in your archive is from today.
ARCHIVE_DIR="/volume1/photos/archive"
newest_file_date=$(find "$ARCHIVE_DIR" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2- | xargs -I {} date -r {} +%F)
today_date=$(date +%F)


if [ "$newest_file_date" != "$today_date" ]; then
  echo "CRITICAL: No new backups found in $ARCHIVE_DIR for today, $today_date!"
fi
