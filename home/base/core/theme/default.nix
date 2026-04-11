{
  lib,
  pkgs,
  ...
}:
###############################################################################
#
# Custom theme module (`mytheme`)
#
# Exposes a single palette + font across all programs that opt into it, by
# reading the current variant from `<repo-root>/vars/theme`. Valid values:
#   - tango-light
#   - tango-dark
#
# Use `theme-switch {light|dark|toggle}` to swap variants — the script rewrites
# `vars/theme` and reruns home-manager.
#
# Downstream modules read:
#   - config.mytheme.variant     # "light" or "dark"
#   - config.mytheme.colors      # full palette attrset (see palettes.nix)
#   - config.mytheme.font        # font family name (default: Source Code Pro)
#   - config.mytheme.tmThemePath # path to the matching syntect .tmTheme file
#
# NOTE: This module coexists with the existing `theme.nix` (catppuccin global)
# without conflict — they declare different option namespaces. zellij/neovim
# still use catppuccin via their own config; they'll be migrated separately.
#
###############################################################################
let
  # Trim trailing newline so `echo tango-light > vars/theme` works as expected.
  themeName = lib.strings.removeSuffix "\n" (builtins.readFile ../../../../vars/theme);
  palettes = import ./palettes.nix;
  palette =
    palettes.${themeName} or (throw
      "mytheme: vars/theme contains '${themeName}'; expected 'tango-light' or 'tango-dark'"
    );

  theme-switch = pkgs.writeShellScriptBin "theme-switch" (builtins.readFile ./theme-switch.sh);
in
{
  options.mytheme = {
    variant = lib.mkOption {
      type = lib.types.enum [
        "light"
        "dark"
      ];
      description = "Current theme variant (light or dark).";
    };
    colors = lib.mkOption {
      type = lib.types.attrs;
      description = "Active palette. See palettes.nix for the full schema.";
    };
    font = lib.mkOption {
      type = lib.types.str;
      default = "Source Code Pro";
      description = "Default monospace font family used across terminals.";
    };
    tmThemePath = lib.mkOption {
      type = lib.types.path;
      description = "Path to the syntect .tmTheme file matching the active variant.";
    };
  };

  config = {
    mytheme = {
      variant = palette.variant;
      colors = palette;
      tmThemePath = ./tmThemes + "/${themeName}.tmTheme";
    };

    home.packages = [ theme-switch ];
  };
}
