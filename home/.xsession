#!/bin/bash

. "$HOME/.profile"

XMONAD_BIN="$HOME/.cache/xmonad/xmonad-x86_64-linux"

if [ ! -f "$XMONAD_BIN" ]; then
  xmonad --recompile
fi

if [ -f "$XMONAD_BIN" ]; then
  exec "$XMONAD_BIN"
else
  exec xmonad
fi

