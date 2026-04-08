{ config, lib, ... }:
let
  hostName = "no-macair-work";
in
{
  imports = [ ../../darwin ];

  # Work machine: override git identity
  programs.git.settings = {
    user.name = lib.mkForce "Radek Janik";
    user.email = lib.mkForce "radek@otee.io";
  };

  programs.ssh.matchBlocks."github.com".identityFile =
    "${config.home.homeDirectory}/.ssh/${hostName}";
}
