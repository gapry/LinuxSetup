#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m' 

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_ROOT="$HOME/backup/LinuxSetup/local$TIMESTAMP"

sync_item() {
  local src_dir="$1"
  local target_base="$HOME/.$src_dir"

  if [ ! -d "$REPO_ROOT/$src_dir" ]; then return; fi

  echo -e "${RED}[Syncing]${RESET} $REPO_ROOT/$src_dir -> $target_base"

  find "$REPO_ROOT/$src_dir" -type f -print0 | while IFS= read -r -d '' file; do
    local rel_path="${file#$REPO_ROOT/$src_dir/}"
    local target_file="$target_base/$rel_path"
    local backup_file="$BACKUP_ROOT/$src_dir/$rel_path"

    if [ -f "$target_file" ]; then
      mkdir -p "$(dirname "$backup_file")"
      cp -p "$target_file" "$backup_file"
      echo -e "  ${GREEN}[Backup]${RESET} $backup_file"
    fi

    mkdir -p "$(dirname "$target_file")"
    cp -p "$file" "$target_file"
    echo -e "  ${BLUE}[Synced]${RESET} $file -> $target_file"
  done
}

sync_item "config"
sync_item "local"

echo "--------------------------------------------------"
echo -e "${GREEN}Local Test Sync Completed.${RESET}"
echo -e "Backup saved at: ${BLUE}$BACKUP_ROOT${RESET}"
echo "--------------------------------------------------"

exec fish

