{ config, ... }:
let
  hostName = "pl-macmini-personal";
in
{
  imports = [ ../../darwin ];

  # Personal machine: use personal git identity (wassp / cyberwassp@gmail.com)
  # This is the default from myvars, no override needed.

  programs.ssh.matchBlocks."github.com".identityFile =
    "${config.home.homeDirectory}/.ssh/${hostName}";
}
