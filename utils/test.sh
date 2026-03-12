#!/bin/sh

set -e

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_DIR="$HOME/backup/LinuxSetup/local-$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

APPS=$(find "$REPO_ROOT/config" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)

echo "Backing up current configs to $BACKUP_DIR..."
for app in $APPS; do
  if [ -d "$HOME/.config/$app" ]; then
    cp -pr "$HOME/.config/$app" "$BACKUP_DIR/"
  fi
done

echo "Syncing configurations from Repo to ~/.config..."
for app in $APPS; do
  mkdir -p "$HOME/.config/$app"
  cp -pr "$REPO_ROOT/config/$app/." "$HOME/.config/$app/"
  echo "Synced: $app"
done

echo "--------------------------------------------------"
echo "Local Test Sync Completed."
echo "Backup saved at: $BACKUP_DIR"

exec fish
