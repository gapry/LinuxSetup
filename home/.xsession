#!/bin/bash

. "$HOME/.profile"

# xrandr --listmonitors

xrandr --output HDMI-0 --primary --auto --pos 0x0 \
  --output DP-0 --auto --right-of HDMI-0

XMONAD_BIN="$HOME/.cache/xmonad/xmonad-x86_64-linux"

if [ ! -f "$XMONAD_BIN" ]; then
  xmonad --recompile
fi

if [ -f "$XMONAD_BIN" ]; then
  exec "$XMONAD_BIN"
else
  exec xmonad
fi
