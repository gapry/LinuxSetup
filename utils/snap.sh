#!/bin/sh

cat pkgs/snap/packages.list | xargs -I {} sudo snap install {} --classic
