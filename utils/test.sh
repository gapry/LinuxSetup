#!/bin/sh

set -e

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)

TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_DIR="$HOME/backup/LinuxSetup/local-$TIMESTAMP"

echo "Backing up current configs to $BACKUP_DIR..."

mkdir -p "$BACKUP_DIR"

if [ -d "$HOME/.config/fish" ]; then
  cp -r "$HOME/.config/fish" "$BACKUP_DIR/"
fi

if [ -d "$HOME/.config/nix" ]; then
  cp -r "$HOME/.config/nix" "$BACKUP_DIR/"
fi

echo "Ensuring target directories exist..."
mkdir -p "$HOME/.config/nix"
mkdir -p "$HOME/.config/fish"

echo "Syncing configurations from Repo to ~/.config..."
cp -pr "$REPO_ROOT/config/nix/"* "$HOME/.config/nix/"
rsync -av "$REPO_ROOT/config/fish/" "$HOME/.config/fish/"

echo "--------------------------------------------------"
echo "Local Test Sync Completed."
echo "Backup saved at: $BACKUP_DIR"

echo "Re-run 'source ~/.config/fish/config.fish' to apply changes."
