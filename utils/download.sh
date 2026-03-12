#!/bin/sh

set -e

UPSTREAM="https://github.com/gapry/LinuxSetup/archive/refs/heads/main.tar.gz"
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_DIR="$HOME/backup/LinuxSetup/remote-$TIMESTAMP"
TEMP_DIR=$(mktemp -d)

mkdir -p "$BACKUP_DIR"

echo "Downloading configurations from $UPSTREAM..."
curl -Lf --output "$TEMP_DIR/archive.tar.gz" "$UPSTREAM"

echo "Unpacking archive..."
tar -xzf "$TEMP_DIR/archive.tar.gz" -C "$TEMP_DIR" --strip-components=1
rm -f "$TEMP_DIR/archive.tar.gz"

APPS=$(find "$TEMP_DIR/config" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
for app in $APPS; do
  if [ -d "$HOME/.config/$app" ]; then
    cp -pr "$HOME/.config/$app" "$BACKUP_DIR/"
  fi

  mkdir -p "$HOME/.config/$app"
  cp -pr "$TEMP_DIR/config/$app/." "$HOME/.config/$app/"
  echo "Synced: $app"
done

rm -rf "$TEMP_DIR"

echo "--------------------------------------------------"
echo "Remote Installation Completed Successfully."
echo "Full backup saved at: $BACKUP_DIR"

echo "Re-run 'source ~/.config/fish/config.fish' to apply changes."

