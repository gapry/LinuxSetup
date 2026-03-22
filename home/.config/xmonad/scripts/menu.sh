#!/bin/bash

options="Lock\nLogout\nReboot\nShutdown"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "System:" -theme-str 'window {width: 200px;}')

case $chosen in
  Lock)
    i3lock 
    ;;
  Logout)
    pkill xmonad
    ;;
  Reboot)
    systemctl reboot
    ;;
  Shutdown)
    systemctl poweroff
    ;;
  *)
    exit 0
    ;;
esac
