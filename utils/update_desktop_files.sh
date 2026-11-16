#!/bin/sh

set -eu

for src_file in "$1"/.local/share/applications/*.desktop; do
  [ -f "$src_file" ] || continue

  dst_file="$HOME/.local/share/applications/${src_file##*/}"

  sed 's|\$HOME|'"$HOME"'|g' "$src_file" > "$dst_file"
done
