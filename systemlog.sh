#!/usr/bin/env bash 

# If Fails Stop
set -e

# System Log

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
HOSTNAME=$(hostname)
OS=$(cat /etc/os-release)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
MEMORY=$(free -h)
DISK=$(df -h /)
CPU=$(lscpu | grep "Model name")

REPORT="$HOME/HomeLab/Log/systemlog-$DATE.txt"
exec > "$REPORT"

echo "==SYSTEM LOG=="
echo "Date: $DATE"
echo "Time: $TIME"
echo "Hostname: $HOSTNAME"
echo "OS: $OS"
echo "Kernel: $KERNEL"
echo "==UPTIME=="
echo "Uptime: $UPTIME"
echo "==MEMORY USAGE=="
echo "$MEMORY"
echo "==DISK USAGE=="
echo "$DISK"
echo "==CPU INFORMATION=="
echo "$CPU"
echo "==SYSTEM LOAD=="
echo "Load Average: $LOAD"
echo "==SYSTEM ERRORS (24 HRS)"
if [ -z "$ERRORS" ]; then
	echo "No Errors to Report."
else
	echo "$ERRORS"
fi


