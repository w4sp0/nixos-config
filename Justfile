# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Common commands(suitable for all machines)
#
############################################################################

# List all the just commands
default:
    @just --list

# Run eval tests
[group('nix')]
test:
  nix eval .#evalTests --show-trace --print-build-logs --verbose

# Update all the flake inputs
[group('nix')]
up:
  nix flake update --commit-lock-file

# Update specific input
# Usage: just upp nixpkgs
[group('nix')]
upp input:
  nix flake update {{input}} --commit-lock-file

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
[group('nix')]
repl:
  nix repl -f flake:nixpkgs

# remove all old generations
# on darwin, you may need to switch to root user to run this command
[group('nix')]
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system
  nix profile wipe-history --profile "${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager"

# Garbage collect all unused nix store entries
[group('nix')]
gc:
  sudo nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d

# Enter a shell session which has all the necessary tools for this flake
[macos]
[group('nix')]
shell:
  nix shell nixpkgs#git nixpkgs#neovim

[group('nix')]
fmt:
  find . -name '*.nix' -exec nixfmt {} +

# Show all the auto gc roots in the nix store
[group('nix')]
gcroot:
  ls -al /nix/var/nix/gcroots/auto/

# Verify all the store entries
[group('nix')]
verify-store:
  nix store verify --all

# Repair Nix Store Objects
[group('nix')]
repair-store *paths:
  nix store repair {{paths}}

############################################################################
#
#  Darwin related commands
#
############################################################################

[macos]
[group('desktop')]
darwin-rollback:
  ./result/sw/bin/darwin-rebuild --rollback

# Deploy the darwinConfiguration by hostname match
[macos]
[group('desktop')]
local mode="default":
  #!/usr/bin/env zsh
  set -e
  name=$(hostname)
  echo "darwin-build '${name}' in '{{mode}}' mode..."
  echo "=================================================="
  target=".#darwinConfigurations.${name}.system"
  NIX="/nix/var/nix/profiles/default/bin/nix"
  if [[ "{{mode}}" == "debug" ]]; then
    $NIX build "${target}" --extra-experimental-features "nix-command flakes" --show-trace --verbose
  else
    $NIX build "${target}" --extra-experimental-features "nix-command flakes"
  fi
  echo "darwin-switch '${name}' in '{{mode}}' mode..."
  echo "=================================================="
  if [[ "{{mode}}" == "debug" ]]; then
    sudo -E ./result/sw/bin/darwin-rebuild switch --flake ".#${name}" --show-trace --verbose
  else
    sudo -E ./result/sw/bin/darwin-rebuild switch --flake ".#${name}"
  fi

# Reset launchpad to force it to reindex Applications
[macos]
[group('desktop')]
reset-launchpad:
  defaults write com.apple.dock ResetLaunchPad -bool true
  killall Dock

############################################################################
#
#  Other useful commands
#
############################################################################

[group('common')]
path:
   echo $PATH | tr ':' '\n'

# Remove all reflog entries and prune unreachable objects
[group('git')]
ggc:
  git reflog expire --expire-unreachable=now --all
  git gc --prune=now

# Amend the last commit without changing the commit message
[group('git')]
game:
  git commit --amend -a --no-edit

[group('github')]
gh-login:
  gh auth login -h github.com --skip-ssh-key --git-protocol ssh
