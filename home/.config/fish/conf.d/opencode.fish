if status is-interactive
  set -gx OPENCODE_MODEL "codegemma:2b"
  set -gx OPENCODE_HOST "http://localhost:11434"

  fish_add_path $HOME/.opencode/bin
end
