{
  # Disable catppuccin's btop theme; btop's built-in "Default" theme uses the
  # terminal's default fg/bg and ANSI palette, so it follows our tango theme.
  catppuccin.btop.enable = false;

  # replacement of htop/nmon
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false; # make btop transparent
      color_theme = "Default";
    };
  };
}
