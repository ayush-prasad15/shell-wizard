#!/bin/bash

#___________________README________________________________________#
#create log file with write permissions
#sudo touch /var/log/disk_alert.log
#sudo chown $(whoami) /var/log/disk_alert.log
#crontab -e
# */15 * * * * /path/to/task1_disk_space_alert.sh  -> run every 15 mins
#__________________________________________________________________#


# Default values
DEFAULT_THRESHOLD=80
DEFAULT_EMAIL="your@mail.com"
LOG_FILE="/var/log/disk_alert.log"

# Function to send email alert
send_alert() {
    local usage=$1
    local threshold=$2
    local hostname=$(hostname)
    local timestamp=$(date)
    local subject="Disk Space Alert on $hostname"
    local body="hostname = $hostname has exceeded the threshold of $threshold%.

Current usage: $usage%
Timestamp: $timestamp"

    echo -e "$body" | mailx -s "$subject" "$EMAIL"
}

# Get threshold from CLI argument or environment variable
if [ -n "$1" ]; then
    THRESHOLD=$1
elif [ -n "$DISK_ALERT_THRESHOLD" ]; then
    THRESHOLD=$DISK_ALERT_THRESHOLD
else
    THRESHOLD=$DEFAULT_THRESHOLD
fi

# Get email from CLI argument or environment variable
if [ -n "$2" ]; then
    EMAIL=$2
elif [ -n "$DISK_ALERT_EMAIL" ]; then
    EMAIL=$DISK_ALERT_EMAIL
else
    EMAIL=$DEFAULT_EMAIL
fi

# Get disk usage
disk_usage_percentage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

# Log the check
timestamp=$(date)
echo "$timestamp - Current usage: $disk_usage_percentage%" >> "$LOG_FILE"

# Check if usage exceeds threshold
if [ "$disk_usage_percentage" -ge "$THRESHOLD" ]; then
    send_alert "$disk_usage_percentage" "$THRESHOLD"
    echo "$timestamp - Alert sent to $EMAIL" >> "$LOG_FILE"
fi