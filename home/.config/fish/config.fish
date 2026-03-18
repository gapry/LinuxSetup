if status is-interactive
  fish_default_key_bindings

  set -gx BUN_INSTALL "$HOME/.bun"
  set -gx OPENCODE_MODEL "codegemma:2b"
  set -gx OPENCODE_HOST "http://localhost:11434"

  fish_add_path $BUN_INSTALL/bin
  fish_add_path $HOME/.opencode/bin

  if type -q starship
    starship init fish | source
  end
end

