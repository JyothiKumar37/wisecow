#!/bin/bash

# Thresholds

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

LOG_FILE="/var/log/system_health.log"

echo "===== Health Check: $(date) =====" >> $LOG_FILE

# CPU Usage

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d'.' -f1)

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
echo "[ALERT] CPU Usage is ${CPU_USAGE}%." | tee -a $LOG_FILE
fi

# Memory Usage

MEM_USAGE=$(free | awk '/Mem/ {printf("%.0f", $3/$2 * 100)}')

if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
echo "[ALERT] Memory Usage is ${MEM_USAGE}%." | tee -a $LOG_FILE
fi

# Disk Usage

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
echo "[ALERT] Disk Usage is ${DISK_USAGE}%." | tee -a $LOG_FILE
fi

# Process Check

PROCESSES=("sshd" "cron")

for PROCESS in "${PROCESSES[@]}"
do
if ! pgrep "$PROCESS" > /dev/null
then
echo "[ALERT] Process $PROCESS is not running." | tee -a $LOG_FILE
fi
done

echo "Health check completed."
