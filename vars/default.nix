{ lib }:
{
  username = "wasspds";
  userfullname = "wassp";
  useremail = "cyberwassp@gmail.com";
  networking = import ./networking.nix { inherit lib; };

  # Public Keys for SSH access to all machines.
  # Generate via: ssh-keygen -t ed25519 -a 256 -C "user@<hostname>" -f ~/.ssh/<hostname>
  mainSshAuthorizedKeys = [
    # TODO: Replace with your actual SSH public keys
    # "ssh-ed25519 AAAA... user@pl-macmini-personal"
    # "ssh-ed25519 AAAA... user@no-macair-work"
  ];
  secondaryAuthorizedKeys = [
    # backup ssh keys for disaster recovery
  ];
}
