#!/bin/sh

set -e

echo "Updating Ubuntu..."
sudo apt update

echo "Installing Ubuntu packages..."
sudo apt install -y $(cat pkgs/ubuntu/packages.txt)

if ! groups $(whoami) | grep -q -w "nix-users"; then
  echo "Adding $(whoami) to nix-users group..."
  sudo usermod -aG nix-users $(whoami)

  echo "Restarting nix-daemon to apply group changes..."
  sudo systemctl restart nix-daemon
fi

echo "Ubuntu setup completed."
