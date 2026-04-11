{
  config,
  pkgs,
  ...
}:
###########################################################
#
# Alacritty Configuration
#
# Palette and font come from `config.mytheme` — see
# `home/base/core/theme/default.nix`. Toggle light/dark with `theme-switch`.
#
# Useful Hot Keys for macOS:
#   1. Multi-Window: `command + N`
#   2. Increase Font Size: `command + =` | `command + +`
#   3. Decrease Font Size: `command + -` | `command + _`
#   4. Search Text: `command + F`
#   5. And Other common shortcuts such as Copy, Paste, Cursor Move, etc.
#
# Useful Hot Keys for Linux:
#   1. Increase Font Size: `ctrl + shift + =` | `ctrl + shift + +`
#   2. Decrease Font Size: `ctrl + shift + -` | `ctrl + shift + _`
#   3. Search Text: `ctrl + shift + N`
#   4. And Other common shortcuts such as Copy, Paste, Cursor Move, etc.
#
# Note: Alacritty do not have support for Tabs, and any graphic protocol.
#
###########################################################
let
  c = config.mytheme.colors;
in
{
  catppuccin.alacritty.enable = false;

  programs.alacritty = {
    enable = true;
    # https://alacritty.org/config-alacritty.html
    settings = {
      window = {
        opacity = 1.0;
        startup_mode = "Maximized"; # Maximized window
        dynamic_title = true;
        option_as_alt = "Both"; # Option key acts as Alt on macOS
        decorations = "None"; # Show neither borders nor title bar
      };
      scrolling = {
        history = 10000;
      };
      font = {
        bold = {
          family = config.mytheme.font;
        };
        italic = {
          family = config.mytheme.font;
        };
        normal = {
          family = config.mytheme.font;
        };
        bold_italic = {
          family = config.mytheme.font;
        };
        size = 13;
      };
      colors = {
        primary = {
          background = c.bg;
          foreground = c.fg;
        };
        cursor = {
          cursor = c.cursor;
          text = c.bg;
        };
        selection = {
          background = c.selection_bg;
          text = c.selection_fg;
        };
        normal = {
          black = c.ansi.black;
          red = c.ansi.red;
          green = c.ansi.green;
          yellow = c.ansi.yellow;
          blue = c.ansi.blue;
          magenta = c.ansi.magenta;
          cyan = c.ansi.cyan;
          white = c.ansi.white;
        };
        bright = {
          black = c.ansi.brBlack;
          red = c.ansi.brRed;
          green = c.ansi.brGreen;
          yellow = c.ansi.brYellow;
          blue = c.ansi.brBlue;
          magenta = c.ansi.brMagenta;
          cyan = c.ansi.brCyan;
          white = c.ansi.brWhite;
        };
      };
      terminal = {
        shell = {
          program = "/bin/zsh";
          args = [ "--login" ];
        };
        osc52 = "CopyPaste";
      };
    };
  };
}
