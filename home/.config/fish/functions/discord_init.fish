function discord_init
  if test (count $argv) -gt 1
    echo "Usage: discord_init [repository-path]" >&2
    return 1
  end

  set -l repo_root "$PWD"
  if test (count $argv) -eq 1
    set repo_root "$argv[1]"
  end

  set -l profile "$repo_root/etc/apparmor.d/discord"
  if not test -f "$profile"
    echo "Error: AppArmor profile not found: $profile" >&2
    return 1
  end

  if not command -q apparmor_parser
    echo "Error: apparmor_parser is not installed." >&2
    return 1
  end

  sudo install -m 644 -- "$profile" /etc/apparmor.d/discord
  or return $status

  sudo apparmor_parser -r /etc/apparmor.d/discord
end
