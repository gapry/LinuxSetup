#!/bin/bash

set -e

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

source "$REPO_ROOT/utils/color.sh"
source "$REPO_ROOT/utils/sync_file.sh"

UPSTREAM="https://github.com/gapry/LinuxSetup/archive/refs/heads/main.tar.gz"
TEMP_DIR=$(mktemp -d)

echo -e "${RED}[Download]${RESET} Fetching configurations from $UPSTREAM..."
curl -Lf --output "$TEMP_DIR/archive.tar.gz" "$UPSTREAM"

echo -e "${RED}[Unpack]${RESET} Extracting archive to temporary directory..."
tar -xzf "$TEMP_DIR/archive.tar.gz" -C "$TEMP_DIR" --strip-components=1
rm -f "$TEMP_DIR/archive.tar.gz"

timestamp=$(date +%Y%m%d%H%M%S)
backup_root="$HOME/backup/LinuxSetup/remote-$timestamp"
mkdir -p "$backup_root"

dirs=("config" "local")
for dir in "${dirs[@]}"; do
  sync_file "$TEMP_DIR/home/$dir" "$dir" "$backup_root"
done

rm -rf "$TEMP_DIR"

echo "--------------------------------------------------"
echo -e "${GREEN}Remote Installation Completed Successfully.${RESET}"
echo -e "Backup saved at: ${BLUE}$backup_root${RESET}"
echo "--------------------------------------------------"

exec fish

