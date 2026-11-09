#!/bin/sh

set -e

for tool in curl gzip; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$tool" >&2
    exit 1
  fi
done

coursier_url="https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz"
coursier_bin="$HOME/.local/share/coursier/bin"
coursier_jvm="temurin:1.25.0.2"

mkdir -p "$coursier_bin"

echo "Installing coursier..."
curl -fL "$coursier_url" | gzip -d > "$coursier_bin/cs.tmp"
chmod +x "$coursier_bin/cs.tmp"
mv "$coursier_bin/cs.tmp" "$coursier_bin/cs"

echo "Installing JVM $coursier_jvm..."
"$coursier_bin/cs" setup --yes --env --jvm "$coursier_jvm" --install-dir "$coursier_bin" >/dev/null

echo "Coursier setup completed."

