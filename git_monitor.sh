#!/bin/bash

# The remote Git repository to monitor
REPO_URL="https://github.com/github-username/your-project.git"
LOCAL_DIR="path/to/local_project_folder"
LOG_FILE="/var/log/my_git_logger.log"
CHECK_INTERVAL=60

# Function to log messages
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check if the local directory exists
if [ ! -d "$LOCAL_DIR" ]; then
  log "Local directory '$LOCAL_DIR' not found. Cloning repository..."
  git clone "$REPO_URL" "$LOCAL_DIR" >> "$LOG_FILE" 2>&1
  if [ $? -ne 0 ]; then
    log "Error: Failed to clone repository. Exiting."
    exit 1
  fi
fi

cd "$LOCAL_DIR" || exit

log "Git monitor started for repository: $REPO_URL"
log "Monitoring local directory: $(pwd)"

while true; do
  log "Fetching remote..."
  git fetch >> "$LOG_FILE" 2>&1

  # Check for new commits
  LOCAL_HASH=$(git rev-parse HEAD)
  REMOTE_HASH=$(git rev-parse '@{u}')

  if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
    log "New commits found. Pulling changes..."
    git pull >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
      NEW_COMMIT_HASH=$(git rev-parse HEAD)
      log "Successfully pulled new changes. New HEAD is at $NEW_COMMIT_HASH"
      log "Status: Restarting application (simulation)..." # Placeholder for restart logic
    else
      log "Error: Failed to pull changes."
    fi
  else
    log "No new commits found."
  fi

  log "Waiting for $CHECK_INTERVAL seconds..."
  sleep "$CHECK_INTERVAL"
done
