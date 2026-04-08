_:
#############################################################
#
#  no-macair-work - MacBook Air M2 (Work)
#
#############################################################
let
  hostname = "no-macair-work";
in
{
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  # Work-specific apps
  homebrew.casks = [
    "slack"
  ];
}
