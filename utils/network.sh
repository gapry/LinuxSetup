#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Permission denied"
  exec sudo "$0" "$@"
fi

if [ -f "etc/NetworkManager/NetworkManager.conf" ]; then
  if [ -f "/etc/NetworkManager/NetworkManager.conf" ]; then
    echo "[Back] NetworkManager.conf to NetworkManager.conf.bak"
    cp /etc/NetworkManager/NetworkManager.conf "/etc/NetworkManager/NetworkManager.conf.bak-$(date +'%Y%m%d-%H%M%S')"
  fi

  echo "[Deploy] Upstream NetworkManager.conf"
  cp etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
  chown root:root /etc/NetworkManager/NetworkManager.conf
  chmod 644 /etc/NetworkManager/NetworkManager.conf
 
  nmcli connection reload
fi

GW_DEV=$(ip route show default | awk '/default/ {print $5; exit}')
echo "[Device] $GW_DEV"

if [ -z "$GW_DEV" ]; then
  echo "[Error] No default gateway device found."
  exit 1
fi

CON_NAME=$(nmcli -t -f NAME,DEVICE connection show --active | grep ":${GW_DEV}$" | cut -d: -f1)
echo "[Connection] $CON_NAME"

if [ -n "$CON_NAME" ]; then
  nmcli connection modify "$CON_NAME" \
    ipv4.dns "1.1.1.1"                \
    ipv4.ignore-auto-dns yes          \
    ipv6.dns "2606:4700:4700::1111"   \
    ipv6.ignore-auto-dns yes

  nmcli connection up "$CON_NAME"
fi

echo "[Check]"
resolvectl status "$GW_DEV"

echo "[Double Check]"
resolvectl dns
