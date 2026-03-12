#!/bin/bash

set -e

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_DIR="$HOME/backup/LinuxSetup/local-$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

find "$REPO_ROOT/config" -maxdepth 1 -mindepth 1 -type d -print0 | while IFS= read -r -d '' dir; do
  app=$(basename "$dir")

  if [ -d "$HOME/.config/$app" ]; then
    cp -pr "$HOME/.config/$app" "$BACKUP_DIR/"
    echo "Backup: $BACKUP_DIR/$app"
  fi

  mkdir -p "$HOME/.config/$app"
  cp -pr "$REPO_ROOT/config/$app/." "$HOME/.config/$app/"
  echo "Synced: $HOME/.config/$app"
done

echo "--------------------------------------------------"
echo "Local Test Sync Completed."
echo "Backup saved at: $BACKUP_DIR"
echo "--------------------------------------------------"

exec fish
