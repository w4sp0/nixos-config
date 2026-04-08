{ config, lib, ... }:
let
  envExtra = ''
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
  '';
in
{
  # Homebrew's default install location:
  #   /opt/homebrew for Apple Silicon
  #   /usr/local for macOS Intel
  programs.bash = {
    enable = true;
    bashrcExtra = lib.mkAfter envExtra;
  };
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    inherit envExtra;
    initExtra = ''
      bindkey -e
    '';
  };
}
