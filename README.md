Here is a comprehensive `README.md` file for your collection of scripts. I have assigned logical filenames to each script (e.g., `script_01.sh`) to make the documentation easy to follow.

You can save this content directly as `README.md`.

-----

# Linux System Administration & Monitoring Scripts

This repository contains a collection of Bash scripts designed for Linux system administration, automated disk monitoring, git repository synchronization, and user management.

-----

## Prerequisites

To run these scripts successfully, ensure the following utilities are installed on your Linux system:

  * **Bash** (Standard on most Linux distros)
  * **Git** (For the repository monitor)
  * **Mailx** or **Mailutils** (Crucial for sending email alerts)

To install mail utilities:

```bash
# Ubuntu/Debian
sudo apt-get install mailutils

# RHEL/CentOS
sudo yum install mailx
```

-----

## Installation

1.  Save the scripts into a dedicated directory (e.g., `/opt/scripts/` or `~/scripts/`).
2.  Make the scripts executable using the following command:

<!-- end list -->

```bash
chmod +x *.sh
```

-----

## Script Documentation

### 1\. Boot History Checker

**Filename:** `check_reboots.sh`

Displays the 5 most recent system reboots to help track system stability.

**Usage:**

```bash
./check_reboots.sh
```

-----

### 2\. Disk Space Alert Monitor

**Filename:** `disk_alert.sh`

Checks the root (`/`) file system usage. If usage exceeds a specific threshold, it sends an email alert and logs the event.

**Setup (One-time):**
You must create the log file and assign permissions before running:

```bash
sudo touch /var/log/disk_alert.log
sudo chown $(whoami) /var/log/disk_alert.log
```

**Configuration:**
You can run this script with default values (Threshold: 80%), or pass arguments:

```bash
# Method 1: Default run
./disk_alert.sh

# Method 2: Custom arguments (Threshold, Email)
./disk_alert.sh 90 admin@example.com

# Method 3: Environment Variables
export DISK_ALERT_THRESHOLD=85
export DISK_ALERT_EMAIL="admin@example.com"
./disk_alert.sh
```

**Automation (Cron):**
To run this every 15 minutes:

```bash
*/15 * * * * /path/to/disk_alert.sh
```

-----

### 3\. Daily Disk Usage Reporter

**Filename:** `daily_disk_report.sh`

Generates a formatted table of all mounted file systems and emails it to the administrator.

**Configuration:**
Open the script and edit the `RECIPIENT_EMAIL` variable:

```bash
RECIPIENT_EMAIL="your@mail.com"
```

**Automation (Cron):**
To send the report every day at 2:18 PM:

```bash
18 14 * * * /path/to/daily_disk_report.sh
```

-----

### 4\. Git Repository Auto-Syncer

**Filename:** `git_monitor.sh`

A daemon-like script that runs continuously. It checks a remote Git repository for changes every 60 seconds. If changes are detected, it pulls them and logs the activity.

**Configuration:**
Edit the following variables inside the script before running:

  * `REPO_URL`: The HTTPS URL of your git repo.
  * `LOCAL_DIR`: The path where the project should be cloned/updated.
  * `LOG_FILE`: Location for logs.

**Usage:**
It is recommended to run this in the background:

```bash
nohup ./git_monitor.sh &
```

-----

### 5\. User List Extractor

**Filename:** `extract_users.sh`

Reads the `/etc/passwd` file, extracts just the usernames, and appends them to a file named `userlist.txt` in the current directory.

**Usage:**

```bash
./extract_users.sh
cat userlist.txt
```

-----

## Logging & Troubleshooting

  * **Disk Alerts:** Logs are stored in `/var/log/disk_alert.log`.
  * **Git Monitor:** Logs are stored in `/var/log/my_git_logger.log`.

**Common Issues:**

1.  **Email not received:** Check your spam folder and ensure `mailx` is configured with a valid MTA (like Postfix or Sendmail).
2.  **Permission Denied:** Ensure the user running the script has write permissions to the `/var/log/` files.

-----
