#!/usr/bin/env bash

set -euo pipefail

mysql_bin="$1"
config_file="$2"
data_dir="$3"
runtime_dir="$4"
socket_addr="$5"
sql_file="$6"

if [ -e "$data_dir.bootstrap-incomplete" ]; then
  echo "MySQL initialization was interrupted; manual recovery is required." >&2
  exit 1
fi

if [ -d "$data_dir/mysql" ]; then
  if [ ! -f "$data_dir/.shepherd-auth-configured" ]; then
    echo "Existing MySQL data requires manual migration before Shepherd setup." >&2
    exit 1
  fi
  exit 0
fi

mkdir -p -m 700 "$data_dir" "$runtime_dir"
chmod 700 "$data_dir" "$runtime_dir"
touch "$data_dir.bootstrap-incomplete"

"$mysql_bin/mysqld" \
  --defaults-file="$config_file" \
  --initialize-insecure \
  --datadir="$data_dir"

"$mysql_bin/mysqld" \
  --defaults-file="$config_file" \
  --skip-networking \
  --pid-file="$runtime_dir/bootstrap.pid" &
mysql_pid=$!
trap 'kill "$mysql_pid" 2>/dev/null || true; wait "$mysql_pid" 2>/dev/null || true' EXIT

ready=
for attempt in $(seq 1 60); do
  if "$mysql_bin/mysqladmin" --no-defaults --protocol=SOCKET \
    --socket="$socket_addr" --user=root ping >/dev/null 2>&1; then
    ready=1
    break
  fi
  if ! kill -0 "$mysql_pid" 2>/dev/null; then
    break
  fi
  sleep 1
done

if [ -z "$ready" ]; then
  echo "MySQL bootstrap server failed to start." >&2
  exit 1
fi

username="$(id -un)"
if [ "$username" = root ]; then
  echo "MySQL initialization requires a non-root OS user." >&2
  exit 1
fi

username_hex="$(printf %s "$username" | od -An -v -tx1 | tr -d ' \n')"
{
  printf "SET @username = CONVERT(UNHEX('%s') USING utf8mb4);\n" "$username_hex"
  cat "$sql_file"
} | "$mysql_bin/mysql" --no-defaults --protocol=SOCKET \
  --socket="$socket_addr" --user=root

kill "$mysql_pid"
wait "$mysql_pid"
trap - EXIT
touch "$data_dir/.shepherd-auth-configured"
rm "$data_dir.bootstrap-incomplete"
