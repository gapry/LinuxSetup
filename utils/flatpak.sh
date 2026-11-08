#!/bin/sh

set -e

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

xargs -r sudo flatpak install -y flathub < pkgs/flatpak/packages.list
