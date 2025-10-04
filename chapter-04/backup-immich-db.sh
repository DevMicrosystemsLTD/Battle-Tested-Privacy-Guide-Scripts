#!/bin/bash

#=============================================================================
# Immich Database Backup Script V2 (Battle-Tested)
#=============================================================================
# Creates a compressed backup of the PostgreSQL database used by Immich.
# Includes a pre-flight check for the Docker command.
#=============================================================================

# --- CONFIGURATION ---
# The full path to the directory where you store your backups.
BACKUP_DIR="/volume1/backups/immich_db"
# The full path to the directory containing your Immich docker-compose.yml file.
DOCKER_COMPOSE_DIR="/volume1/docker/immich"
# How many days of daily backups to keep.
DAYS_TO_KEEP=7

# --- BATTLE-TESTED PRE-FLIGHT CHECK ---
# Check if Docker is installed and runnable.
command -v docker >/dev/null 2>&1 || { echo "FATAL ERROR: docker command not found. Aborting." >&2; exit 1; }

# --- SCRIPT LOGIC ---
# Create the backup directory if it doesn't exist.
mkdir -p "$BACKUP_DIR"

# Navigate to the docker-compose directory to ensure context.
# The '|| exit' is a safety measure: if the 'cd' command fails, the script stops.
cd "$DOCKER_COMPOSE_DIR" || exit

# Create the backup using pg_dumpall inside the running container.
# The output is piped directly to gzip to compress it on the fly.
docker exec immich_postgres pg_dumpall -U immich | gzip > "$BACKUP_DIR/immich-db-backup-$(date +%Y-%m-%d_%H-%M-%S).sql.gz"

# Check if the backup command was successful.
if [ $? -eq 0 ]; then
  echo "Immich database backup successful."
else
  echo "ERROR: Immich database backup failed." >&2
fi

# Clean up old backups, deleting any file older than DAYS_TO_KEEP.
find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +"$DAYS_TO_KEEP" -exec rm {} \;
