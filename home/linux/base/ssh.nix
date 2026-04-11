{ ... }:
###############################################################################
#
# Linux-specific SSH client overrides.
#
# Drops a file into `~/.ssh/config.d/` that is included by the base hardened
# config shipped from `home/base/tui/ssh/`. Options set here cannot weaken the
# crypto/auth settings enforced by the base `Host *` block — they can only add
# options the base didn't mention.
#
# Currently a stub. Add linux-specific options here as the need arises
# (e.g. IdentityAgent pointing at gnupg-agent's socket, hardware-key
# constraints, wayland/xdg-ssh-askpass wiring, etc.).
#
###############################################################################
{
  home.file.".ssh/config.d/10-linux.conf".text = ''
    ## Linux-specific client behavior.
    ## (intentionally empty — placeholder for future additions)
    Host *
        AddKeysToAgent yes
  '';
}
