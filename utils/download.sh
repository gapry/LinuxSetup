#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

UPSTREAM="https://github.com/gapry/LinuxSetup/archive/refs/heads/main.tar.gz"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_ROOT="$HOME/backup/LinuxSetup/remote$TIMESTAMP"
TEMP_DIR=$(mktemp -d)

sync_item() {
  local src_dir="$1"
  local target_base="$HOME/.$src_dir"
  local src_path="$TEMP_DIR/$src_dir"

  if [ ! -d "$src_path" ]; then return; fi

  echo -e "${RED}[Sync]${RESET} Remote $src_dir -> $target_base"

  find "$src_path" -type f -print0 | while IFS= read -r -d '' file; do
    local rel_path="${file#$src_path/}"
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

echo -e "${RED}[Download]${RESET} Fetching configurations from $UPSTREAM..."
curl -Lf --output "$TEMP_DIR/archive.tar.gz" "$UPSTREAM"

echo -e "${RED}[Unpack]${RESET} Extracting archive to temporary directory..."
mkdir -p "$BACKUP_ROOT"
tar -xzf "$TEMP_DIR/archive.tar.gz" -C "$TEMP_DIR" --strip-components=1
rm -f "$TEMP_DIR/archive.tar.gz"

sync_item "config"
sync_item "local"

rm -rf "$TEMP_DIR"

echo "--------------------------------------------------"
echo -e "${GREEN}Remote Installation Completed Successfully.${RESET}"
echo -e "Backup saved at: ${BLUE}$BACKUP_ROOT${RESET}"
echo "--------------------------------------------------"

exec fish
