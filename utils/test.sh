#!/bin/bash

set -e

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)

source "$REPO_ROOT/utils/color.sh"
source "$REPO_ROOT/utils/sync_file.sh"

TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_ROOT="$HOME/backup/LinuxSetup/$TIMESTAMP"

sync_file "$REPO_ROOT/config" "config"
sync_file "$REPO_ROOT/local" "local"

echo "--------------------------------------------------"
echo -e "${GREEN}Local Test Sync Completed Successfully.${RESET}"
echo -e "Backup saved at: ${BLUE}$BACKUP_ROOT${RESET}"
echo "--------------------------------------------------"

exec fish

