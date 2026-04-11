{ config, pkgs, ... }:
{
  # Disable catppuccin's yazi theme; we ship a hand-written theme below that
  # uses ANSI color names so yazi inherits the active tango-{light,dark}
  # palette from the terminal. File-preview syntax highlighting is handled
  # separately via a tmTheme that swaps on variant.
  catppuccin.yazi.enable = false;

  # terminal file manager
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    # Changing working directory when exiting Yazi
    enableBashIntegration = true;
    enableNushellIntegration = true;
    shellWrapperName = "yy";
    settings = {
      mgr = {
        show_hidden = true;
        sort_dir_first = true;
      };
    };

    # Theme uses ANSI color names (`red`, `bright-yellow`, `reset`, ...) so it
    # follows whatever palette the terminal is using. See
    # home/base/core/theme/default.nix for the active variant.
    theme = {
      mgr = {
        cwd = { fg = "cyan"; };
        hovered = { reversed = true; };
        preview_hovered = { underline = true; };

        find_keyword = {
          fg = "yellow";
          italic = true;
        };
        find_position = {
          fg = "magenta";
          bg = "reset";
          italic = true;
        };

        marker_copied = {
          fg = "green";
          bg = "green";
        };
        marker_cut = {
          fg = "red";
          bg = "red";
        };
        marker_marked = {
          fg = "cyan";
          bg = "cyan";
        };
        marker_selected = {
          fg = "magenta";
          bg = "magenta";
        };

        count_copied = {
          fg = "black";
          bg = "green";
        };
        count_cut = {
          fg = "black";
          bg = "red";
        };
        count_selected = {
          fg = "black";
          bg = "magenta";
        };

        border_symbol = "│";
        border_style = { fg = "bright black"; };

        # Syntect (preview) theme is hex-based; swap on variant.
        syntect_theme = config.mytheme.tmThemePath;
      };

      tabs = {
        active = {
          reversed = true;
          bold = true;
        };
        inactive = { fg = "bright black"; };
      };

      mode = {
        normal_main = {
          fg = "black";
          bg = "magenta";
          bold = true;
        };
        normal_alt = {
          fg = "magenta";
          bg = "reset";
        };

        select_main = {
          fg = "black";
          bg = "green";
          bold = true;
        };
        select_alt = {
          fg = "green";
          bg = "reset";
        };

        unset_main = {
          fg = "black";
          bg = "red";
          bold = true;
        };
        unset_alt = {
          fg = "red";
          bg = "reset";
        };
      };

      status = {
        sep_left = {
          open = "";
          close = "";
        };
        sep_right = {
          open = "";
          close = "";
        };

        progress_label = { bold = true; };
        progress_normal = { fg = "green"; };
        progress_error = {
          fg = "yellow";
          bg = "red";
        };

        perm_type = { fg = "blue"; };
        perm_read = { fg = "yellow"; };
        perm_write = { fg = "red"; };
        perm_exec = { fg = "green"; };
        perm_sep = { fg = "bright black"; };
      };

      which = {
        mask = { bg = "reset"; };
        cand = { fg = "cyan"; };
        rest = { fg = "bright black"; };
        desc = { fg = "magenta"; };
        separator = "  ";
        separator_style = { fg = "bright black"; };
      };

      input = {
        border = { fg = "blue"; };
        title = { };
        value = { };
        selected = { reversed = true; };
      };

      confirm = {
        border = { fg = "blue"; };
        title = { fg = "blue"; };
        content = { };
        list = { };
        btn_yes = { reversed = true; };
        btn_no = { };
        btn_labels = [
          "[Y(es)]"
          "[(N)o]"
        ];
      };

      pick = {
        border = { fg = "blue"; };
        active = {
          fg = "magenta";
          bold = true;
        };
        inactive = { };
      };

      cmp = {
        border = { fg = "blue"; };
        active = { reversed = true; };
        inactive = { };
        icon_file = { fg = "cyan"; };
        icon_folder = { fg = "blue"; };
        icon_command = { fg = "magenta"; };
      };

      tasks = {
        border = { fg = "blue"; };
        title = { };
        hovered = { underline = true; };
      };

      help = {
        on = { fg = "cyan"; };
        run = { fg = "magenta"; };
        desc = { fg = "yellow"; };
        hovered = {
          reversed = true;
          bold = true;
        };
        footer = {
          fg = "black";
          bg = "white";
        };
      };

      notify = {
        title_info = { fg = "green"; };
        title_warn = { fg = "yellow"; };
        title_error = { fg = "red"; };
      };

      filetype = {
        rules = [
          # Orphan / dangling symlinks
          {
            name = "*";
            is = "orphan";
            fg = "red";
          }
          # Executable files
          {
            name = "*";
            is = "exec";
            fg = "green";
          }
          # Images
          {
            mime = "image/*";
            fg = "magenta";
          }
          # Videos
          {
            mime = "video/*";
            fg = "magenta";
            bold = true;
          }
          # Audio
          {
            mime = "audio/*";
            fg = "yellow";
          }
          # Archives
          {
            mime = "application/zip";
            fg = "red";
            bold = true;
          }
          {
            mime = "application/gzip";
            fg = "red";
            bold = true;
          }
          {
            mime = "application/x-tar";
            fg = "red";
            bold = true;
          }
          {
            mime = "application/x-bzip";
            fg = "red";
            bold = true;
          }
          {
            mime = "application/x-bzip2";
            fg = "red";
            bold = true;
          }
          {
            mime = "application/x-7z-compressed";
            fg = "red";
            bold = true;
          }
          {
            mime = "application/x-rar";
            fg = "red";
            bold = true;
          }
          {
            mime = "application/xz";
            fg = "red";
            bold = true;
          }
          # Documents
          {
            mime = "application/pdf";
            fg = "cyan";
          }
          {
            mime = "application/msword";
            fg = "cyan";
          }
          {
            mime = "application/vnd.openxmlformats-officedocument.*";
            fg = "cyan";
          }
          # Directories
          {
            name = "*/";
            bold = true;
          }
          # Fallback
          {
            name = "*";
            fg = "reset";
          }
        ];
      };
    };
  };
}
