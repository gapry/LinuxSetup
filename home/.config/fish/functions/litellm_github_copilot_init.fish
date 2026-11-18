function litellm_github_copilot_init
  if not command -q pipx
    echo "Error: pipx is not installed." >&2
    return 1
  end

  set -l pipx_home (command pipx environment --value PIPX_HOME)
  or return $status

  set -l python "$pipx_home/venvs/litellm/bin/python"
  if not test -x "$python"
    echo "Error: LiteLLM is not installed. Run make pip from the repository first." >&2
    return 1
  end

  "$python" -c 'from litellm.llms.github_copilot.authenticator import Authenticator; Authenticator().get_api_key(); print("Copilot credentials are ready")'
end
