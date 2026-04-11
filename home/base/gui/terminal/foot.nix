{
  config,
  lib,
  pkgs,
  ...
}:
let
  c = config.mytheme.colors;
  # foot wants hex values WITHOUT the `#` prefix.
  stripHash = lib.strings.removePrefix "#";
in
{
  catppuccin.foot.enable = false;

  programs.foot = {
    # foot is designed only for Linux
    enable = pkgs.stdenv.isLinux;

    # foot can also be run in a server mode. In this mode, one process hosts multiple windows.
    # All Wayland communication, VT parsing and rendering is done in the server process.
    # New windows are opened by running footclient, which remains running until the terminal window is closed.
    #
    # Advantages to run foot in server mode including reduced memory footprint and startup time.
    # The downside is a performance penalty. If one window is very busy with, for example, producing output,
    # then other windows will suffer. Also, should the server process crash, all windows will be gone.
    server.enable = true;

    # https://man.archlinux.org/man/foot.ini.5
    settings = {
      main = {
        term = "foot"; # or "xterm-256color" for maximum compatibility
        font = "${config.mytheme.font}:size=13";
        dpi-aware = "no"; # scale via window manager instead
        resize-keep-grid = "no"; # do not resize the window on font resizing

        # Spawn a nushell in login mode via `bash`
        shell = "${pkgs.bash}/bin/bash --login -c 'nu --login --interactive'";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      # Palette + font come from `config.mytheme` (see home/base/core/theme).
      cursor = {
        color = "${stripHash c.bg} ${stripHash c.cursor}";
      };

      colors = {
        alpha = "1.0";
        background = stripHash c.bg;
        foreground = stripHash c.fg;
        selection-background = stripHash c.selection_bg;
        selection-foreground = stripHash c.selection_fg;

        regular0 = stripHash c.ansi.black;
        regular1 = stripHash c.ansi.red;
        regular2 = stripHash c.ansi.green;
        regular3 = stripHash c.ansi.yellow;
        regular4 = stripHash c.ansi.blue;
        regular5 = stripHash c.ansi.magenta;
        regular6 = stripHash c.ansi.cyan;
        regular7 = stripHash c.ansi.white;

        bright0 = stripHash c.ansi.brBlack;
        bright1 = stripHash c.ansi.brRed;
        bright2 = stripHash c.ansi.brGreen;
        bright3 = stripHash c.ansi.brYellow;
        bright4 = stripHash c.ansi.brBlue;
        bright5 = stripHash c.ansi.brMagenta;
        bright6 = stripHash c.ansi.brCyan;
        bright7 = stripHash c.ansi.brWhite;
      };
    };
  };
}
