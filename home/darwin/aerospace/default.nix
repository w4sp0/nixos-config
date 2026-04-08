{ config, ... }:
{
  home.file.".aerospace.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/homelab/nixos-config/home/darwin/aerospace/aerospace.toml";
}
