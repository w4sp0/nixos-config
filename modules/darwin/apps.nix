{
  config,
  lib,
  pkgs,
  ...
}:
##########################################################################
#
#  Install all apps and packages here.
#
#  NOTE: Your can find all available options in:
#    https://daiderd.com/nix-darwin/manual/index.html
#
#  NOTE: To remove the uninstalled APPs icon from Launchpad:
#    1. `sudo nix store gc --debug` & `sudo nix-collect-garbage --delete-old`
#    2. click on the uninstalled APP's icon in Launchpad, it will show a question mark
#    3. if the app starts normally:
#        1. right click on the running app's icon in Dock, select "Options" -> "Show in Finder" and delete it
#    4. hold down the Option key, a `x` button will appear on the icon, click it to remove the icon
#
##########################################################################
{
  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    neovim
    git
    gnugrep # replace macos's grep
    gnutar # replace macos's tar
  ];
  environment.variables = {
    # Fix https://github.com/LnL7/nix-darwin/wiki/Terminfo-issues
    TERMINFO_DIRS = map (path: path + "/share/terminfo") config.environment.profiles ++ [
      "/usr/share/terminfo"
    ];
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  # homebrew need to be installed manually, see https://brew.sh
  # https://github.com/LnL7/nix-darwin/blob/master/modules/homebrew.nix
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    masApps = {
      # Xcode = 497799835;
    };

    brews = [
      "wget" # download tool
      "curl" # do not install curl via nixpkgs, it's not working well on macOS!
      "aria2" # download tool
      "wireguard-tools" # wireguard
      "container" # https://github.com/apple/container

      # https://github.com/rgcr/m-cli
      "m-cli" # Swiss Army Knife for macOS
      "proxychains-ng"

      # commands like `gsed` `gtar` are required by some tools
      "gnu-sed"
      "gnu-tar"

      # misc that nix do not have cache for.
      "git-trim"
      "hashicorp/tap/terraform"
      "terraformer"
    ];

    taps = [
      "nikitabobko/tap" # aerospace - an i3-like tiling window manager for macOS
      "hashicorp/tap"
    ];

    # `brew install --cask`
    casks = [
      "google-chrome"

      "alacritty" # terminal emulator

      "nikitabobko/tap/aerospace" # an i3-like tiling window manager for macOS

      # container & vm
      "utm" # vm

      # tailscale - install manually, conflicts with existing installation
      # "tailscale-app"

      # AI
      "lm-studio"

      # Communication
      "discord"

      # Misc
      "iina" # video player
      "stats" # beautiful system status monitor in menu bar

      "neteasemusic" # music
      "blender@lts" # 3D creation suite
      "clash-verge-rev" # the same as mihomo-party

      # Development
      "mitmproxy" # HTTP/HTTPS traffic inspector
      "insomnia" # REST client
      "wireshark-app" # network analyzer

      # Setup macfuse: https://github.com/macfuse/macfuse/wiki/Getting-Started
      "macfuse" # for rclone to mount a fuse filesystem
    ];
  };
}
