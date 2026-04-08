{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    clash-meta
  ];

  home.file.".proxychains/proxychains.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/homelab/nixos-config/home/darwin/proxy/proxychains.conf";
}
