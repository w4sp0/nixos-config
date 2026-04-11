#!/usr/bin/env bash
#
# theme-switch — toggle between tango-light and tango-dark.
#
# Writes the new variant into `$REPO/vars/theme`, then reruns the
# platform-appropriate rebuild command. Because the theme module reads
# this file at eval time (via builtins.readFile on a flake-relative path),
# changing the file invalidates the nix store hash and triggers a real
# rebuild — no --impure, no manual intervention.
#
# Usage:
#   theme-switch light
#   theme-switch dark
#   theme-switch toggle
#
# Rebuild command is selected by OS:
#   - Darwin → darwin-rebuild switch --flake $REPO#$(hostname -s)
#   - Linux  → sudo nixos-rebuild switch --flake $REPO#$(hostname -s)
#
# Override the repo path with HOMELAB_REPO, or replace the rebuild command
# entirely with HOMELAB_THEME_REBUILD_CMD (takes the flake target as $1).

set -euo pipefail

REPO="${HOMELAB_REPO:-$HOME/src/homelab/nixos-config}"
FILE="$REPO/vars/theme"

if [[ ! -f "$FILE" ]]; then
  echo "theme-switch: $FILE not found" >&2
  echo "              (is HOMELAB_REPO set correctly?)" >&2
  exit 1
fi

case "${1:-}" in
  light)
    new=tango-light
    ;;
  dark)
    new=tango-dark
    ;;
  toggle)
    current=$(tr -d '[:space:]' < "$FILE")
    case "$current" in
      tango-light) new=tango-dark ;;
      tango-dark)  new=tango-light ;;
      *)
        echo "theme-switch: unknown current theme in $FILE: '$current'" >&2
        exit 1
        ;;
    esac
    ;;
  ""|-h|--help)
    cat >&2 <<EOF
usage: theme-switch {light|dark|toggle}

  light   — switch to tango-light
  dark    — switch to tango-dark
  toggle  — flip to the other variant

env:
  HOMELAB_REPO              path to the flake repo
                            (default: \$HOME/src/homelab/nixos-config)
  HOMELAB_THEME_REBUILD_CMD override the rebuild command; receives the
                            flake target (e.g. REPO#hostname) as \$1
EOF
    exit 0
    ;;
  *)
    echo "theme-switch: unknown arg '$1'" >&2
    exit 1
    ;;
esac

echo "$new" > "$FILE"
printf '→ theme: %s\n' "$new"

host=$(hostname -s)
target="$REPO#$host"

if [[ -n "${HOMELAB_THEME_REBUILD_CMD:-}" ]]; then
  echo "→ $HOMELAB_THEME_REBUILD_CMD $target"
  exec $HOMELAB_THEME_REBUILD_CMD "$target"
fi

case "$(uname -s)" in
  Darwin)
    echo "→ darwin-rebuild switch --flake $target"
    exec darwin-rebuild switch --flake "$target"
    ;;
  Linux)
    echo "→ sudo nixos-rebuild switch --flake $target"
    exec sudo nixos-rebuild switch --flake "$target"
    ;;
  *)
    echo "theme-switch: unsupported OS: $(uname -s)" >&2
    echo "              set HOMELAB_THEME_REBUILD_CMD to override" >&2
    exit 1
    ;;
esac
