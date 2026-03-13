#!/bin/bash

set -e

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

source "$REPO_ROOT/utils/color.sh"
source "$REPO_ROOT/utils/sync_file.sh"

sync_file "$REPO_ROOT/config" "config"
sync_file "$REPO_ROOT/local" "local"

echo "--------------------------------------------------"
echo -e "${GREEN}Local Test Sync Completed Successfully.${RESET}"

exec fish

