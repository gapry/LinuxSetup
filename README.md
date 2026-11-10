## Overview
This repository explores maximizing the use of [XMonad](https://xmonad.org/) for window management,
[Nix](https://nixos.org/learn/) for declarative package management and
[GNU Shepherd](https://shepherding.services/) for user service supervision
on [Ubuntu](https://ubuntu.com/) and [NixOS](https://nixos.org/) with the [fish shell](https://fishshell.com/)

## Install
```sh
curl -fsSL https://raw.githubusercontent.com/gapry/LinuxSetup/main/utils/install.sh | sh
```

## Usage

### System
```sh
make ubuntu                         # update apt, install Ubuntu packages, and configure group membership
make nixos                          # deploy etc/nixos to /etc/nixos and run nixos-rebuild switch
make snap                           # install packages from the Snap list
make flatpak                        # configure Flathub and install packages from the Flatpak list
make curl                           # install coursier and the Temurin JVM
```

### Home Manager
```sh
make nixpkgs-init                   # initialize Home Manager
make nixpkgs-update                 # update flake inputs and apply Home Manager configuration
make nixpkgs-gc                     # remove unreferenced Nix store paths
make nixpkgs-remove-all-generations # delete old generations and collect garbage
make nixpkgs-channel-version        # show the configured nixpkgs version
make nixpkgs-show-generations       # list Home Manager generations
make nixpkg-bytehound               # build Bytehound and link it at ~/.local/share/bytehound
make nixpkg-graphite                # build Graphite with nixGL and link it at ~/.local/share/graphite-app
```

### Development
```sh
make local                          # back up and sync local home/ changes to $HOME for quick testing
make format                         # format *.nix with nixpkgs-fmt
make flake-lock                     # refresh both flake.lock files
make xmonad-test                    # recompile and test XMonad in Xephyr
```

### QEMU
```sh
make qemu-ubuntu                    # boot the Ubuntu QEMU environment
make qemu-ubuntu-test               # boot the Ubuntu VM and run install.sh against the working tree
make qemu-nixos                     # boot the NixOS QEMU environment
make qemu-nixos-test                # boot the NixOS VM and run install.sh against the working tree
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

### NixOS

```text
+-------------------------------------------------------------+
|                         NixOS                               |
|            /etc/nixos  <--  etc/nixos (repository)          |
+----------------------------+--------------------------------+
                             |
                nixos-rebuild switch --flake #linuxsetup
                             |
                         flake.nix
               imports every <subdir>/*.nix module
                             |
     +-----------+-----------+-----------+-----------+
     |           |           |           |           |
   nix/       shell/        wm/       desktop/     input/
   nix.nix    fish.nix    xmonad.nix  flatpak.nix  fcitx5.nix
   nix-ld.nix             lightdm

     +-----------+-----------+-----------+-----------+
     |           |           |           |           |
   audio/      font/      network/    container/   packages/
   pipewire    fonts.nix  NetworkManager docker.nix one *.nix
   volumeicon             nm-applet                per tool
                             |
            configuration.nix + hardware-configuration.nix
              (machine specific, kept out of the repo)
```

### Shared Home Layer

```text
                     utils/install.sh
                   reads /etc/os-release
                             |
              +--------------+--------------+
              |                             |
           ubuntu                         nixos
     utils/os/ubuntu.sh              utils/os/nixos.sh
     apt / snap / flatpak        /etc/nixos + nixos-rebuild
              |                             |
              +--------------+--------------+
                             |
                      pkgs/curl/curl.sh
                    coursier + Temurin JVM
                             |
                   home/ -> $HOME (sync_file)
                             |
              home-manager switch --impure
                             |
                builtins.pathExists /etc/NIXOS
              +--------------+--------------+
              |                             |
            false                         true
     targets.genericLinux            plain Home Manager
     nixGL (nvidia | mesa)           no nixGL wrapping
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

## Testing

```text
 host                                       guest
+------------------------------------+     +----------------------------------------------+
| make qemu-<os>-test                |     | boot                                         |
|   sync_shared.sh                   |     |   autologin                                  |
|     worktree -> tests/qemu/shared/ |     |   mount 9p shared -> /mnt/shared             |
|     LinuxSetup/ + test.log         | --> |   LINUXSETUP_DIR=/mnt/shared/LinuxSetup      |
|   qemu-system-x86_64               |     |   sh /mnt/shared/LinuxSetup/utils/install.sh |
|     -virtfs shared (9p)            |     |   verify fish / nix / HM / cs                |
|     -enable-kvm                    | <-- |   tee /mnt/shared/test.log                   |
+------------------------------------+     |   LINUXSETUP TEST PASSED | FAILED            |
                                           +----------------------------------------------+
```

### Ubuntu VM

```text
downloads/ubuntu-26.04-server-cloudimg-amd64.img
                   |
                   | backing file
                   v
.cache/qemu/ubuntu-test.qcow2        tests/qemu/ubuntu/cloud-init-test.yaml
                   |                                   |
                   |                          xorriso -> seed.iso (cidata)
                   |                                   |
                   +----------------+------------------+
                                    |
                           qemu -nographic
                                    |
                      cloud-init (first boot only)
                        sudoers, ttyS0 autologin,
                        /etc/profile.d trigger, fstab 9p
                                    |
                        tests/qemu/ubuntu/guest-test.sh
```

### NixOS VM

```text
tests/qemu/nixos/build.sh
  |
  |  etc/nixos + tests/qemu/nixos/{configuration,hardware-configuration}.nix
  |  nix build .#nixosConfigurations.linuxsetup.config.system.build.vm
  |
  |  Home Manager for user tester prebuilt on host
  |  closure + flake inputs -> LINUXSETUP_VM_PATHS
  |  -> virtualisation.additionalPaths
  v
.cache/qemu/nixos/vm/bin/run-linuxsetup-qemu-vm
  |
  |  kernel + initrd from host store, host /nix/store over 9p (ro)
  |  qcow2 holds guest writes only, no bootloader
  |
  +-- run.sh   GTK window, xterm login shell
  +-- test.sh  QEMU_KERNEL_PARAMS=linuxsetup.test, xterm runs the test
```

### VM Storage
Both VMs keep their disk between runs.
Delete the qcow2 under `.cache/qemu/` to start from a clean machine.
Shut the guest down with `sudo poweroff` so the Nix SQLite caches are flushed.

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

### Coding Agents

#### Claude Code
```fish
curl -fsSL https://claude.ai/install.sh | bash
```

#### Codex
```fish
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

#### GitHub Copilot CLI
```fish
npm install -g @github/copilot
```

#### Mistral Vibe
```fish
curl -LsSf https://mistral.ai/vibe/install.sh | bash
```

#### Herdr
```fish
curl -fsSL https://herdr.dev/install.sh | sh
```

#### LiteLLM
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
herd status glances
herd start glances
herd restart glances
herd stop glances

herd start litellm-anthropic
herd status litellm-anthropic
herd restart litellm-anthropic
herd stop litellm-anthropic

herd start litellm-openai
herd status litellm-openai
herd restart litellm-openai
herd stop litellm-openai
```

