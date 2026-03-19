function reset_shepherd
  systemctl --user stop shepherd 2>/dev/null
  pkill -9 shepherd 2>/dev/null
  rm -rf /run/user/(id -u)/shepherd/
  systemctl --user daemon-reload
  systemctl --user reset-failed shepherd
  systemctl --user start shepherd
  systemctl --user start shepherd
  sleep 0.5
  systemctl --user status shepherd
end
