#!/bin/sh

set -e

echo "Updating Ubuntu..."
sudo apt update

echo "Installing Ubuntu packages..."
sudo apt install -y $(cat pkgs/ubuntu/packages.txt)

if ! groups | grep -q -w "nix-users"; then
  user=$(whoami)

  sudo usermod -aG nix-users "$user"
  echo "Added $user to nix-users group."

  sudo systemctl restart nix-daemon
  echo "nix-daemon restarted. IMPORTANT: Log out and log back in for group changes to apply to your user."
fi

echo "Ubuntu setup completed."
