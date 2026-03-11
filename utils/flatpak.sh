#!/bin/sh

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

cat pkgs/flatpak/packages.txt | xargs sudo flatpak install -y flathub
