#!/bin/sh

set -e

xargs -r -I {} sudo snap install {} --classic < pkgs/snap/packages.list
