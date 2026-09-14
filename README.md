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
   |    |     |                                          |                 |
xmobar GUI  Alacritty                                  Redis         cloudflared
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

## Config
```
$ nvim ~/.env
```
```
ANTHROPIC_AUTH_TOKEN=
OPENCLAW_GATEWAY_TOKEN=
OPENCLAW_AGENTS_DEFAULTS_WORKSPACE=
OPENCLAW_CHANNELS_TELEGRAM_BOT_TOKEN=
OPENCLAW_CHANNELS_TELEGRAM_ALLOW_USERS_ID=
```
