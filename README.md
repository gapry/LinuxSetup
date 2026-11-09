## Overview
This repository explores maximizing the use of [XMonad](https://xmonad.org/) for window management,
[Nix](https://nixos.org/learn/) for declarative package management and 
[GNU Shepherd](https://shepherding.services/) for user service supervision
on a popular Linux distribution with the [fish shell](https://fishshell.com/)

## Install
```sh
curl -fsSL https://raw.githubusercontent.com/gapry/LinuxSetup/main/utils/install.sh | sh
```

## Usage 
```sh
make qemu-ubuntu              # boot the Ubuntu QEMU environment
make qemu-nixos               # boot the NixOS QEMU environment
make local                    # back up and sync local home/ changes to $HOME for quick testing
make format                   # format *.nix with nixpkgs-fmt
make xmonad-test              # recompile and test XMonad in Xephyr
make ubuntu                   # update apt, install Ubuntu packages, and configure group membership
make snap                     # install packages from the Snap list
make flatpak                  # configure Flathub and install packages from the Flatpak list
make nixpkgs-init             # initialize Home Manager
make nixpkgs-update           # update flake inputs and apply Home Manager configuration
make nixpkgs-gc               # remove unreferenced Nix store paths
make nixpkgs-channel-version  # show the configured nixpkgs version
make nixpkgs-show-generations # list Home Manager generations
make nixpkg-bytehound         # build Bytehound and link it at ~/.local/share/bytehound
make nixpkg-graphite          # build Graphite with nixGL and link it at ~/.local/share/graphite-app
```

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

