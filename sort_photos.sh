#!/bin/bash

#=============================================================================
# The Drill Sergeant - Photo & Video Sorter Script V2 (Battle-Tested)
#=============================================================================
# This script moves files from a source directory to a destination,
# organizing them into a YYYY/MM folder structure based on EXIF date.
# Includes dependency check and improved logging.
#=============================================================================

# --- CONFIGURATION ---
# IMPORTANT: Use full paths. Do not use relative paths.
SOURCE_DIR="/volume1/photos/uploads"
DEST_DIR="/volume1/photos/archive"
LOG_FILE="/volume1/scripts/logs/sorter.log"

# --- BATTLE-TESTED PRE-FLIGHT CHECK ---
# Check if exiftool is installed before starting. A real pro checks his weapon.
command -v exiftool >/dev/null 2>&1 || {
  echo "FATAL ERROR: exiftool is not installed. Aborting." >&2
  exit 1
}

# --- SCRIPT LOGIC ---
# Create a log file directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Log the start of the script
echo "=========================================" >> "$LOG_FILE"
echo "Drill Sergeant script started at $(date)" >> "$LOG_FILE"

# Find all files and process them safely
find "$SOURCE_DIR" -type f -print0 | while IFS= read -r -d $'\0' file; do
    
    # THE CORE COMMAND: Use exiftool to move the file.
    # '-d' sets the date format for the new directory structure.
    # '%Y/%m' creates Year/Month folders (e.g., 2025/10).
    # The '-P' option preserves the file modification date.
    # The '-o .' is a dummy option; the real magic is in the directory format.
    # Errors are redirected to the log file for troubleshooting.
    exiftool -o . -P "-Directory<DateTimeOriginal" \
        -d "$DEST_DIR/%Y/%m" "$file" >> "$LOG_FILE" 2>&1

    # Check if exiftool was successful by seeing if the original file still exists.
    if [ ! -f "$file" ]; then
        echo "SUCCESS: Moved '$file'." >> "$LOG_FILE"
    else
        echo "WARNING: Could not process '$file'. It may lack EXIF data or have permission issues." >> "$LOG_FILE"
    fi
done

echo "Script finished at $(date)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
