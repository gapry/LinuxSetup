function launch_litellm
  set -l config_file ~/.litellm/config.yaml
  set -l port_num 4000

  if not type -q litellm
    echo "Error: litellm is not installed"
    return 1
  end

  if not test -f $config_file
    echo "Error: litellm config file does not exist"
    return 1
  end

  litellm --config $config_file --port $port_num
end
