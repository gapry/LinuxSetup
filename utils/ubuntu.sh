#!/bin/sh

set -e

echo "Updating Ubuntu..."
sudo apt update

echo "Installing Ubuntu packages..."
xargs -r sudo apt install -y < pkgs/ubuntu/packages.list

user=$(whoami)

if getent group nix-users >/dev/null 2>&1 && ! groups | grep -q -w "nix-users"; then
  sudo usermod -aG nix-users "$user"
  echo "Added $user to nix-users group."

  sudo systemctl restart nix-daemon
  echo "nix-daemon restarted. IMPORTANT: Log out and log back in for group changes to apply to your user."
fi

if getent group docker >/dev/null 2>&1 && ! groups | grep -q -w "docker"; then
  sudo usermod -aG docker "$user"
  echo "Docker group membership updated. Permissions will take effect after logout."
fi

echo "Ubuntu setup completed."
