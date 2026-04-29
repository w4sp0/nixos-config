# NixOS Configuration

This repository is home to the nix code that builds my systems:

1. NixOS Desktops: NixOS with home-manager, niri, agenix, etc.
2. macOS Desktops: nix-darwin with home-manager, share the same home-manager configuration with
   NixOS Desktops.
3. NixOS Servers: virtual machines running on Proxmox/KubeVirt, with various services, such as
   kubernetes, homepage, prometheus, grafana, etc.

See [./hosts](./hosts) for details of each host.

See [./Virtual-Machine.md](./Virtual-Machine.md) for details of how to create & manage KubeVirt's
Virtual Machine from this flake.

## Why NixOS & Flakes?

Nix allows for easy-to-manage, collaborative, reproducible deployments. This means that once
something is setup and configured once, it works (almost) forever. If someone else shares their
configuration, anyone else can just use it (if you really understand what you're copying/referring
now).

## Components

|                                                                | NixOS(Wayland)                                                                                                      |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **Window Manager**                                             | [Niri][Niri]                                                                                                        |
| **Terminal Emulator**                                          | [Zellij][Zellij] + [foot][foot]/[Kitty][Kitty]/[Alacritty][Alacritty]/[Ghostty][Ghostty]                            |
| **Status Bar** / **Notifier** / **Launcher** / **lockscreens** | [noctalia-shell][noctalia-shell]                                                                                    |
| **Display Manager**                                            | [tuigreet][tuigreet]                                                                                                |
| **Color Scheme**                                               | [catppuccin-nix][catppuccin-nix]                                                                                    |
| **network management tool**                                    | [NetworkManager][NetworkManager]                                                                                    |
| **Input method framework**                                     | [Fcitx5][Fcitx5] + [rime][rime] + [小鹤音形 flypy][flypy]                                                           |
| **System resource monitor**                                    | [Btop][Btop]                                                                                                        |
| **File Manager**                                               | [Yazi][Yazi] + [thunar][thunar]                                                                                     |
| **Shell**                                                      | [Nushell][Nushell] + [Starship][Starship]                                                                           |
| **Media Player**                                               | [mpv][mpv]                                                                                                          |
| **Text Editor**                                                | [Neovim][Neovim]                                                                                                    |
| **Fonts**                                                      | [Nerd fonts][Nerd fonts]                                                                                            |
| **Image Viewer**                                               | [imv][imv]                                                                                                          |
| **Screenshot Software**                                        | Niri's builtin function                                                                                             |
| **Screen Recording**                                           | [OBS][OBS]                                                                                                          |
| **Filesystem & Encryption**                                    | tmpfs as `/`, [Btrfs][Btrfs] subvolumes on a [LUKS][LUKS] encrypted partition for persistent, unlock via passphrase |
| **Secure Boot**                                                | [lanzaboote][lanzaboote]                                                                                            |



## Secrets Management

See [./secrets](./secrets) for details.

## Agents

See [./agents](./agents) for my reusable cross-project agent files and installer script.

## How to Deploy this Flake?

<!-- prettier-ignore -->
> :red_circle: **IMPORTANT**: **You should NOT deploy this flake directly on your machine :exclamation:
> It will not succeed.** This flake contains my hardware configuration(such as
> [hardware-configuration.nix](hosts/idols-ai/hardware-configuration.nix),
> [Nvidia Support](https://github.com/ryan4yin/nix-config/blob/v0.1.1/hosts/idols-ai/default.nix#L77-L91),
> etc.) which is not suitable for your hardware, and requires my private secrets repository
> [ryan4yin/nix-secrets](https://github.com/ryan4yin/nix-config/tree/main/secrets) to deploy. You
> may use this repo as a reference to build your own configuration.

For NixOS:

> To deploy this flake from NixOS's official ISO image (purest installation method), please refer to
> [./nixos-installer/](./nixos-installer/)

```bash
# deploy one of the configuration based on the hostname
sudo nixos-rebuild switch --flake .#ai-niri

# Deploy the niri nixosConfiguration by hostname match
just niri

# or we can deploy with details
just niri debug
```

For macOS:

```bash
# If you are deploying for the first time,
# 1. install nix & homebrew manually.
# 2. prepare the deployment environment with essential packages available
nix-shell -p just nushell
# 3. comment home-manager's code in lib/macosSystem.nix to speed up the first deployment.
# 4. comment out the proxy settings in scripts/darwin_set_proxy.py if the proxy is not ready yet.

# Deploy the darwinConfiguration by hostname match
just local

# deploy with details
just local debug
```

> [What y'all will need when Nix drives you to drink.](https://www.youtube.com/watch?v=Eni9PPPPBpg)
> (copy from hlissner's dotfiles, it really matches my feelings when I first started using NixOS...)

## References

Other dotfiles that inspired me:

- Nix Flakes
  - [NixOS-CN/NixOS-CN-telegram](https://github.com/NixOS-CN/NixOS-CN-telegram)
  - [notusknot/dotfiles-nix](https://github.com/notusknot/dotfiles-nix)
  - [xddxdd/nixos-config](https://github.com/xddxdd/nixos-config)
  - [bobbbay/dotfiles](https://github.com/bobbbay/dotfiles)
  - [gytis-ivaskevicius/nixfiles](https://github.com/gytis-ivaskevicius/nixfiles)
  - [davidtwco/veritas](https://github.com/davidtwco/veritas)
  - [gvolpe/nix-config](https://github.com/gvolpe/nix-config)
  - [Ruixi-rebirth/flakes](https://github.com/Ruixi-rebirth/flakes)
  - [fufexan/dotfiles](https://github.com/fufexan/dotfiles): gtk theme, xdg, git, media, etc.
  - [nix-community/srvos](https://github.com/nix-community/srvos): a collection of opinionated and
    sharable NixOS configurations for servers
- Modularized NixOS Configuration
  - [hlissner/dotfiles](https://github.com/hlissner/dotfiles)
  - [viperML/dotfiles](https://github.com/viperML/dotfiles)
- Neovim/AstroNvim
  - [maxbrunet/dotfiles](https://github.com/maxbrunet/dotfiles): astronvim with nix flakes.
- Misc
  - [1amSimp1e/dots](https://github.com/1amSimp1e/dots)

[Niri]: https://github.com/YaLTeR/niri
[Kitty]: https://github.com/kovidgoyal/kitty
[foot]: https://codeberg.org/dnkl/foot
[Alacritty]: https://github.com/alacritty/alacritty
[Ghostty]: https://github.com/ghostty-org/ghostty
[Nushell]: https://github.com/nushell/nushell
[Starship]: https://github.com/starship/starship
[Fcitx5]: https://github.com/fcitx/fcitx5
[rime]: https://wiki.archlinux.org/title/Rime
[flypy]: https://flypy.cc/
[Btop]: https://github.com/aristocratos/btop
[mpv]: https://github.com/mpv-player/mpv
[Zellij]: https://github.com/zellij-org/zellij
[Neovim]: https://github.com/neovim/neovim
[AstroNvim]: https://github.com/AstroNvim/AstroNvim
[imv]: https://sr.ht/~exec64/imv/
[OBS]: https://obsproject.com
[Nerd fonts]: https://github.com/ryanoasis/nerd-fonts
[catppuccin-nix]: https://github.com/catppuccin/nix
[NetworkManager]: https://wiki.gnome.org/Projects/NetworkManager
[wl-clipboard]: https://github.com/bugaevc/wl-clipboard
[tuigreet]: https://github.com/apognu/tuigreet
[thunar]: https://gitlab.xfce.org/xfce/thunar
[Yazi]: https://github.com/sxyazi/yazi
[Catppuccin]: https://github.com/catppuccin/catppuccin
[Btrfs]: https://btrfs.readthedocs.io
[LUKS]: https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system
[lanzaboote]: https://github.com/nix-community/lanzaboote
[noctalia-shell]: https://github.com/noctalia-dev/noctalia-shell
