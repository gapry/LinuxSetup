#!/bin/bash

sync_file() {
  local src_path="$1"
  local dst_name="$2"
  local target_base="$HOME/.$dst_name"

  if [ ! -d "$src_path" ]; then return; fi

  echo -e "${RED}[Sync]${RESET} $src_path -> $target_base"

  find "$src_path" -type f -print0 | while IFS= read -r -d '' file; do
    local rel_path="${file#$src_path/}"
    local target_file="$target_base/$rel_path"
    local backup_file="$BACKUP_ROOT/$dst_name/$rel_path"

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
