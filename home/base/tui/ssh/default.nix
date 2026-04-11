{
  config,
  lib,
  pkgs,
  ...
}:
###############################################################################
#
# SSH client configuration
#
# Architecture:
#   - Base hardened config (verbatim from qusal, AGPL-3.0) is shipped as a
#     static file at `./config` and symlinked to `~/.ssh/config`.
#   - Per-host / per-platform overrides live under `~/.ssh/config.d/*.conf`
#     and are loaded by the `Include` directive inside the base config.
#   - Platform contextualization (darwin/linux Keychain, agent behavior, etc.)
#     lives in `home/darwin/ssh.nix` and `home/linux/ssh.nix`; they each drop
#     a numbered file into `~/.ssh/config.d/`.
#   - Qubes contextualization is handled by the `Match Exec` block in the base
#     config itself via runtime detection — no nix module required.
#
# Why not use `programs.ssh.matchBlocks`:
#   The home-manager SSH module can't express `Match Exec`, per-host
#   `UserKnownHostsFile` with `%k`/`%h` substitution, or preserve the verbatim
#   license header. Since `ssh` the client is OS-level (not managed by
#   home-manager), disabling `programs.ssh` just means we write the config
#   ourselves — zero functional loss.
#
# Security model:
#   The hardened `Host *` block is parsed FIRST in the effective config. SSH
#   applies the first value it sees for each option, so crypto/auth settings
#   in that block CANNOT be loosened by any later `config.d/` file — host
#   overrides can only set options the hardened block didn't mention (User,
#   Port, Hostname, IdentityFile, UseKeychain, etc.).
#
###############################################################################
{
  # We manage ~/.ssh/config ourselves; see note above.
  programs.ssh.enable = false;

  home.file = {
    # Base hardened config, shipped verbatim so upstream diffs stay clean.
    ".ssh/config".source = ./config;

    # GitHub via port 443 — useful when port 22 is blocked by a firewall/proxy.
    # Numbered prefix controls load order within config.d/ (lower = earlier).
    ".ssh/config.d/20-github.conf".text = ''
      Host github.com
          Hostname ssh.github.com
          Port 443
          User git
          IdentitiesOnly yes
    '';
  };

  # Ensure the per-host state directories referenced by the base config
  # exist with restrictive permissions. Idempotent; safe to re-run.
  home.activation.ssh-dirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.ssh/known_hosts.d" "$HOME/.ssh/control.d"
    $DRY_RUN_CMD chmod 700 "$HOME/.ssh/known_hosts.d" "$HOME/.ssh/control.d"
  '';
}
