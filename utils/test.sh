#!/bin/bash

set -e

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

source "$REPO_ROOT/utils/color.sh"
source "$REPO_ROOT/utils/sync_file.sh"

timestamp=$(date +%Y%m%d%H%M%S)
backup_root="$HOME/backup/LinuxSetup/local-$timestamp"
mkdir -p "$backup_root"

dirs=("config" "local")
for dir in "${dirs[@]}"; do
  sync_file "$REPO_ROOT/home/$dir" "$dir" "$backup_root"
done

echo "--------------------------------------------------"
echo -e "${GREEN}Local Test Sync Completed Successfully.${RESET}"
echo -e "Backup saved at: ${BLUE}$backup_root${RESET}"
echo "--------------------------------------------------"

exec fish

