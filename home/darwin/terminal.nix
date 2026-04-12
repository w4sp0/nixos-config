{ lib, ... }:
let
  fontSize = 13;
in
{
  programs.alacritty.settings.font.size = lib.mkForce fontSize;
  programs.kitty.font.size = lib.mkForce fontSize;
}
