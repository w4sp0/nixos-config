{ ... }:
###############################################################################
#
# Darwin-specific SSH client overrides.
#
# Drops a file into `~/.ssh/config.d/` that is included by the base hardened
# config shipped from `home/base/tui/ssh/`. Options set here cannot weaken the
# crypto/auth settings enforced by the base `Host *` block — they can only add
# options the base didn't mention.
#
###############################################################################
{
  home.file.".ssh/config.d/10-darwin.conf".text = ''
    ## macOS-specific client behavior.
    ##
    ## UseKeychain  — read/store SSH key passphrases in the macOS Keychain so
    ##                the user isn't prompted on every connection.
    ## AddKeysToAgent — automatically add loaded keys to the running
    ##                  ssh-agent on first use.
    Host *
        UseKeychain yes
        AddKeysToAgent yes
  '';
}
