#!/usr/bin/env bash

set -euo pipefail

postgresql_bin="$1"
data_dir="$2"
socket_dir="$3"

if [ -e "$data_dir.bootstrap-incomplete" ]; then
  echo "PostgreSQL initialization was interrupted; manual recovery is required." >&2
  exit 1
fi

if [ -f "$data_dir/PG_VERSION" ]; then
  exit 0
fi

mkdir -p -m 700 "$data_dir" "$socket_dir"
chmod 700 "$data_dir" "$socket_dir"
touch "$data_dir.bootstrap-incomplete"

"$postgresql_bin/initdb" -D "$data_dir" \
  --auth-local=peer \
  --auth-host=scram-sha-256

rm "$data_dir.bootstrap-incomplete"
