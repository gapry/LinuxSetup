function reset_shepherd
  systemctl --user stop shepherd
  pkill -9 shepherd
  rm -rf /run/user/(id -u)/shepherd/
  systemctl --user daemon-reload
  systemctl --user start shepherd
  systemctl --user status shepherd
end
