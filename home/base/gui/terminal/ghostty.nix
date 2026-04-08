{
  lib,
  ...
}:
###########################################################
#
# Ghostty Configuration - disabled
#
###########################################################
{
  programs.ghostty = {
    enable = lib.mkForce false;
  };
}
