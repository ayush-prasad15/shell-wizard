#!/bin/bash

#_______________README______________________________________________________________
#  chmod +x /path/to/task7_email_disk_usage_report.sh
#  crontab -e
#  18 14 * * * /path/to/task7_email_disk_usage_report.sh
#____________________________________________________________________________________


# Set the recipient email address here
RECIPIENT_EMAIL="your@mail.com"
SUBJECT="Daily Disk Usage Report"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Generate the report body
BODY=$(df -h | awk 'NR>1 {printf "%-50s %-3s %-8s\n", $6, $5, $4}' | column -t)

# the final email content
EMAIL_CONTENT="
Date: $TIMESTAMP

Mount Point          | Usage %%   | Available
-------------------------------------------------
$BODY

"

# Send the email using mailx
echo "${EMAIL_CONTENT}" | mailx -s "${SUBJECT}" "${RECIPIENT_EMAIL}"


