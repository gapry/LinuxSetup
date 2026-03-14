#!/bin/sh

set -e

echo "Updating Ubuntu..."
sudo apt update

echo "Installing Ubuntu packages..."
sudo apt install -y $(cat pkgs/ubuntu/packages.list)

user=$(whoami)

if ! groups | grep -q -w "nix-users"; then
  sudo usermod -aG nix-users "$user"
  echo "Added $user to nix-users group."

  sudo systemctl restart nix-daemon
  echo "nix-daemon restarted. IMPORTANT: Log out and log back in for group changes to apply to your user."
fi

if ! groups | grep -q -w "docker"; then
  sudo usermod -aG docker "$user"
  echo "Docker group membership updated. Permissions will take effect after logout."
fi

echo "Ubuntu setup completed."
