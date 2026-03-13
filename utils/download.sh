#!/bin/bash

set -e

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)

source "$REPO_ROOT/utils/color.sh"
source "$REPO_ROOT/utils/sync_file.sh"

UPSTREAM="https://github.com/gapry/LinuxSetup/archive/refs/heads/main.tar.gz"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_ROOT="$HOME/backup/LinuxSetup/$TIMESTAMP"
TEMP_DIR=$(mktemp -d)

echo -e "${RED}[Download]${RESET} Fetching configurations from $UPSTREAM..."
curl -Lf --output "$TEMP_DIR/archive.tar.gz" "$UPSTREAM"

echo -e "${RED}[Unpack]${RESET} Extracting archive to temporary directory..."
mkdir -p "$BACKUP_ROOT"
tar -xzf "$TEMP_DIR/archive.tar.gz" -C "$TEMP_DIR" --strip-components=1
rm -f "$TEMP_DIR/archive.tar.gz"

sync_file "$TEMP_DIR/config" "config"
sync_file "$TEMP_DIR/local" "local"

rm -rf "$TEMP_DIR"

echo "--------------------------------------------------"
echo -e "${GREEN}Remote Installation Completed Successfully.${RESET}"
echo -e "Backup saved at: ${BLUE}$BACKUP_ROOT${RESET}"
echo "--------------------------------------------------"

exec fish
