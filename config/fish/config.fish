function osquery_init
  alias osq="osqueryi"
  alias osq-cpu="osqueryi --line 'SELECT name, pid, user_time + system_time AS total_time FROM processes ORDER BY total_time DESC LIMIT 5;'"
  alias osq-mem="osqueryi --line 'SELECT name, pid, resident_size FROM processes ORDER BY resident_size DESC LIMIT 5;'"
  alias osq-disk="osqueryi --line 'SELECT device, path, blocks_size * blocks_available AS bytes_free FROM mounts WHERE blocks_size > 0 LIMIT 5;'"
  alias osq-net="osqueryi --line 'SELECT p.name, pos.local_address, pos.remote_address FROM process_open_sockets pos JOIN processes p ON pos.pid = p.pid LIMIT 5;'"
  alias osq-port="osqueryi --line 'SELECT DISTINCT port, address, protocol FROM listening_ports LIMIT 5;'"
end

if status is-interactive
  fish_default_key_bindings

  set -gx GEM_HOME $HOME/gems
  set -gx BUN_INSTALL "$HOME/.bun"
  set -gx OPENCODE_MODEL "codegemma:2b"
  set -gx OPENCODE_HOST "http://localhost:11434"

  fish_add_path $GEM_HOME/bin
  fish_add_path $BUN_INSTALL/bin
  fish_add_path $HOME/.opencode/bin

  if test -d $HOME/.nix-profile/bin
    fish_add_path --move --prepend $HOME/.nix-profile/bin
  end

  if type -q starship
    starship init fish | source
  end

  osquery_init
end

function nixpkg_init
  set -l nix_dir "$HOME/.config/nix"
  set -l user (whoami)

  if test -d $nix_dir
    nix run github:nix-community/home-manager/release-25.11 -- switch -b backup --flake $nix_dir/#$user --impure

    if test -d $HOME/.nix-profile/bin
      fish_add_path --move --prepend $HOME/.nix-profile/bin
    end

    date +%s > $nix_dir/.last_success
  else
    echo "Error: Directory $nix_dir not found."
  end
end

function nixpkg_update
  set -l nix_dir "$HOME/.config/nix"
  set -l user (whoami)
  set -l last_run_file "$nix_dir/.last_success"

  if test -d $nix_dir
    nix flake update --flake $nix_dir
    if home-manager switch --flake $nix_dir/#$user --impure
      date +%s > $last_run_file
    end
  end
end
