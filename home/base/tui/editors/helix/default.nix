{
  lib,
  ...
}:
{
  # Helix editor - disabled
  programs.helix = {
    enable = lib.mkForce false;
  };
}
