#!/bin/bash

BACKUP_SOURCE="/home"
BACKUP_DEST="/var/backups/home"
RETENTION_DAYS=7
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE="home_backup_${TIMESTAMP}.tar.gz"

if [ ! -d "$BACKUP_DEST" ]; then
    mkdir -p "$BACKUP_DEST" || { echo "Could not create $BACKUP_DEST"; exit 1; }
fi

echo "Starting backup of $BACKUP_SOURCE"

if tar -czf "$BACKUP_DEST/$ARCHIVE" "$BACKUP_SOURCE"; then
    SIZE=$(du -h "$BACKUP_DEST/$ARCHIVE" | cut -f1)
    echo "Backup done: $ARCHIVE (Size: $SIZE)"
else
    echo "Backup failed" >&2
    exit 1
fi

echo "Removing backups older than $RETENTION_DAYS days"
find "$BACKUP_DEST" -type f -name "home_backup_*.tar.gz" -mtime +$RETENTION_DAYS -print -delete

echo "Current backups:"
ls -1 "$BACKUP_DEST"/home_backup_*.tar.gz 2>/dev/null | tail -n 20

echo "Done"
