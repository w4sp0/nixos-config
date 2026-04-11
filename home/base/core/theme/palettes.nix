# Tango palette (https://en.wikipedia.org/wiki/Tango_Desktop_Project)
#
# The same 16 ANSI colors are used for both light and dark; only the default
# background/foreground (and a few semantic roles) flip between variants.
# This mirrors how Tango is designed: the palette works on either bg.
{
  tango-light = {
    variant = "light";
    bg = "#FFFFFF";
    fg = "#2E3436";
    cursor = "#2E3436";
    selection_bg = "#D3D7CF";
    selection_fg = "#2E3436";
    comment = "#888A85"; # Tango aluminium
    border = "#BABDB6";
    ansi = {
      black = "#2E3436";
      red = "#CC0000";
      green = "#4E9A06";
      yellow = "#C4A000";
      blue = "#3465A4";
      magenta = "#75507B";
      cyan = "#06989A";
      white = "#D3D7CF";
      brBlack = "#555753";
      brRed = "#EF2929";
      brGreen = "#8AE234";
      brYellow = "#FCE94F";
      brBlue = "#729FCF";
      brMagenta = "#AD7FA8";
      brCyan = "#34E2E2";
      brWhite = "#EEEEEC";
    };
  };

  tango-dark = {
    variant = "dark";
    bg = "#2E3436";
    fg = "#EEEEEC";
    cursor = "#EEEEEC";
    selection_bg = "#555753";
    selection_fg = "#EEEEEC";
    comment = "#888A85";
    border = "#555753";
    ansi = {
      black = "#2E3436";
      red = "#CC0000";
      green = "#4E9A06";
      yellow = "#C4A000";
      blue = "#3465A4";
      magenta = "#75507B";
      cyan = "#06989A";
      white = "#D3D7CF";
      brBlack = "#555753";
      brRed = "#EF2929";
      brGreen = "#8AE234";
      brYellow = "#FCE94F";
      brBlue = "#729FCF";
      brMagenta = "#AD7FA8";
      brCyan = "#34E2E2";
      brWhite = "#EEEEEC";
    };
  };
}
