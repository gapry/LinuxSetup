#!/bin/sh

set -e

UPSTREAM="https://github.com/gapry/LinuxSetup/archive/refs/heads/main.tar.gz"
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_DIR="$HOME/backup/LinuxSetup/remote-$TIMESTAMP"
TEMP_DIR=$(mktemp -d)

echo "Backing up current configs to $BACKUP_DIR..."

mkdir -p "$BACKUP_DIR"

if [ -d "$HOME/.config/fish" ]; then
  cp -pr "$HOME/.config/fish" "$BACKUP_DIR/"
fi

if [ -d "$HOME/.config/nix" ]; then
  cp -pr "$HOME/.config/nix" "$BACKUP_DIR/"
fi

echo "Downloading configurations from $UPSTREAM..."

curl -L "$UPSTREAM" | tar -xz -C "$TEMP_DIR" --strip-components=1

echo "Deploying configurations to ~/.config..."

mkdir -p "$HOME/.config/nix"
mkdir -p "$HOME/.config/fish"

cp -pr "$TEMP_DIR/config/nix/"* "$HOME/.config/nix/"
cp -p "$TEMP_DIR/config/fish/config.fish" "$HOME/.config/fish/config.fish"

rm -rf "$TEMP_DIR"

echo "--------------------------------------------------"
echo "Remote Installation Completed Successfully."
echo "Full backup saved at: $BACKUP_DIR"

echo "Re-run 'source ~/.config/fish/config.fish' to apply changes."

