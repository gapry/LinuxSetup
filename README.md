## Overview
This repository explores maximizing the use of [XMonad](https://xmonad.org/) for window management,
[Nix](https://nixos.org/learn/) for declarative package management and 
[GNU Shepherd](https://shepherding.services/) for user service supervision
on a popular Linux distribution with the [fish shell](https://fishshell.com/)

## Architecture

### Ubuntu 

```text
+-------------------------------------------------------------+
|                        Ubuntu                               |
+----------------------------+--------------------------------+
                             |
        +--------------------+--------------------+
        |                                         |
   DESKTOP (X11)                            systemd --user
        |                                         |
   ~/.xsession                    +---------------+---------------+
        |                         |               |               |
     XMonad                     MySQL         PostgreSQL       Shepherd
        |                                                         |
   +----+-----+                                          +--------+--------+
   |    |     |                                          |        |        |
xmobar GUI  Alacritty                                  Redis   cloudflared  LiteLLM
              |
            Fish
              |
            Zellij
```

### Package Management

```text
                         Fish
                   nixpkg_* functions
                          |
        +-----------------+-----------------+
        |                 |                 |
   nixpkg_init      nixpkg_update       nixpkg_gc
   home-manager     flake update +      nix store gc
      switch          hm switch             |
        |                 |                 v
        +--------+--------+          unreferenced paths
                 |                    (keeps GC roots)
                 v
          Home Manager  <----  flake.nix + flake.lock
             switch             home.nix -> *.nix
                 |              nixpkgs / nixGL / unstable
                 v
                Nix
           build / fetch
                 |
                 v
            Generation
         packages + files
                 |
                 v
            activate
                 |
        +--------+--------+
        |                 |
 ~/.nix-profile      config + units
   CLI tools         Redis / DB / Shepherd
```

## Configuration
```
nvim ~/.env
```
```
ANTHROPIC_AUTH_TOKEN=<Your Key>

LITELLM_MASTER_KEY=<Same Key as ANTHROPIC_AUTH_TOKEN>

OPENCLAW_GATEWAY_TOKEN=
OPENCLAW_AGENTS_DEFAULTS_WORKSPACE=
OPENCLAW_CHANNELS_TELEGRAM_BOT_TOKEN=
OPENCLAW_CHANNELS_TELEGRAM_ALLOW_USERS_ID=
```

### Claude Code
```fish
curl -fsSL https://claude.ai/install.sh | bash
```

### Codex
```fish
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

### GitHub Copilot CLI
```fish
npm install -g @github/copilot
```

### Mistral Vibe
```fish
curl -LsSf https://mistral.ai/vibe/install.sh | bash
```

### Herdr
```fish
curl -fsSL https://herdr.dev/install.sh | sh
```

### LiteLLM
```fish
pipx install 'litellm[proxy]'
```

```fish
~/.local/share/pipx/venvs/litellm/bin/python -c \
  'from litellm.llms.github_copilot.authenticator import Authenticator; Authenticator().get_api_key(); print("Copilot credentials are ready")'
```

### Shepherd
```fish
systemctl --user restart shepherd
```

```fish
herd start litellm-anthropic
herd status litellm-anthropic
herd restart litellm-anthropic
herd stop litellm-anthropic

herd start litellm-openai
herd status litellm-openai
herd restart litellm-openai
herd stop litellm-openai
```

