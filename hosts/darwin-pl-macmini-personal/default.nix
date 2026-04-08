_:
#############################################################
#
#  pl-macmini-personal - Mac Mini M1 (Personal)
#
#############################################################
let
  hostname = "pl-macmini-personal";
in
{
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
}
