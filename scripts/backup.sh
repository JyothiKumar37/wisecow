#!/bin/bash

# Source Directory

SOURCE_DIR="/home/ubuntu/data"

# Backup Details

BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
BACKUP_FILE="/tmp/$BACKUP_NAME"

# Remote Server Details

REMOTE_USER="ubuntu"
REMOTE_HOST="192.168.1.100"
REMOTE_DIR="/home/ubuntu/backups"

LOG_FILE="/var/log/backup.log"

echo "===== Backup Started: $(date) =====" >> $LOG_FILE

# Create Archive

tar -czf $BACKUP_FILE $SOURCE_DIR

if [ $? -eq 0 ]; then
echo "[SUCCESS] Backup archive created." >> $LOG_FILE
else
echo "[FAILED] Archive creation failed." >> $LOG_FILE
exit 1
fi

# Transfer Backup

scp $BACKUP_FILE ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}

if [ $? -eq 0 ]; then
echo "[SUCCESS] Backup transferred successfully." | tee -a $LOG_FILE
else
echo "[FAILED] Backup transfer failed." | tee -a $LOG_FILE
exit 1
fi

echo "Backup completed successfully at $(date)" >> $LOG_FILE
