#!/bin/bash

sync_file() {
  local src_root="$1"
  local backup_root="$2"

  if [ ! -d "$src_root" ]; then return; fi

  echo -e "${RED}[Sync]${RESET} $src_root -> $backup_root"

  find "$src_root" -type f -print0 | while IFS= read -r -d '' file; do
    local rel_path="${file#$src_root/}"
    local target_file="$HOME/$rel_path"
    local backup_file="$backup_root/$rel_path"

    if [ -f "$target_file" ]; then
      mkdir -p "$(dirname "$backup_file")"
      cp -p "$target_file" "$backup_file"
      echo -e "  ${GREEN}[Backup]${RESET} $target_file -> $backup_file"
    fi

    mkdir -p "$(dirname "$target_file")"
    cp -p "$file" "$target_file"
    echo -e "  ${BLUE}[Synced]${RESET} $file -> $target_file"
  done
}
