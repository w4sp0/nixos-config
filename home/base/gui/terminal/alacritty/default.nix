{
  pkgs,
  ...
}:
###########################################################
#
# Alacritty Configuration
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
          family = "Source Code Pro";
        };
        italic = {
          family = "Source Code Pro";
        };
        normal = {
          family = "Source Code Pro";
        };
        bold_italic = {
          family = "Source Code Pro";
        };
        size = 13;
      };
      colors = {
        primary = {
          background = "#FFFFFF";
          foreground = "#2E3436";
        };
        normal = {
          black = "#2E3436";
          red = "#CC0000";
          green = "#4E9A06";
          yellow = "#C4A000";
          blue = "#3465A4";
          magenta = "#75507B";
          cyan = "#06989A";
          white = "#D3D7CF";
        };
        bright = {
          black = "#555753";
          red = "#EF2929";
          green = "#8AE234";
          yellow = "#FCE94F";
          blue = "#729FCF";
          magenta = "#AD7FA8";
          cyan = "#34E2E2";
          white = "#EEEEEC";
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
