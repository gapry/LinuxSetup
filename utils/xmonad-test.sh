#!/bin/bash

DISPLAY_NUM=":10"
SCREEN_SIZE="1024x768"

xmonad --recompile

pkill Xephyr 2>/dev/null

Xephyr -ac -screen $SCREEN_SIZE $DISPLAY_NUM >/dev/null 2>&1 &

XEPHYR_PID=$!

sleep 1

DISPLAY=$DISPLAY_NUM xmonad

kill $XEPHYR_PID 2>/dev/null
