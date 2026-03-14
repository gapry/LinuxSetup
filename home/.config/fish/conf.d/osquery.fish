if type -q osqueryi
  alias osq="osqueryi"
  alias osq-cpu="osqueryi --line 'SELECT name, pid, user_time + system_time AS total_time FROM processes ORDER BY total_time DESC LIMIT 5;'"
  alias osq-mem="osqueryi --line 'SELECT name, pid, resident_size FROM processes ORDER BY resident_size DESC LIMIT 5;'"
  alias osq-disk="osqueryi --line 'SELECT device, path, blocks_size * blocks_available AS bytes_free FROM mounts WHERE blocks_size > 0 LIMIT 5;'"
  alias osq-net="osqueryi --line 'SELECT p.name, pos.local_address, pos.remote_address FROM process_open_sockets pos JOIN processes p ON pos.pid = p.pid LIMIT 5;'"
  alias osq-port="osqueryi --line 'SELECT DISTINCT port, address, protocol FROM listening_ports LIMIT 5;'"
end
