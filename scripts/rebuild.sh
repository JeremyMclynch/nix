#!/usr/bin/env bash
set -e
set -o pipefail

if [ -z "$1" ]; then
  echo "No Argument given, exiting..."
  sleep 1
  exit 1
fi
# cd to your config dir
pushd ~/nix/

# Early return if no changes were detected
if [ -z "$(git diff)" ] && [ "$(git pull)" = "Already up to date." ] && [ "$2" != "force" ]; then
  echo "No changes detected, exiting."
  sleep 1
  popd
  exit 0
fi

# Shows your changes
git diff -U0

#if [[ "$2" == "hold" ]]; then
#  read -n 1 -s -r -p "Continue? [y/N] " ans
#  echo
#  if [[ "$ans" != [yY] ]]; then
#    echo "Aborted."
#    exit 1
#  fi
#fi

echo "Building configuration (no activation)..."

# Build only -- validates the whole config without touching the running system.
# No sudo: an unprivileged build keeps the ./result symlink user-owned.
# Wrap in `script` (a pseudo-tty) so nix/nixos-rebuild still emit ANSI color even
# though stdout is piped into tee; tee then forwards those color codes to screen.
script -qefc "nixos-rebuild build --flake ~/nix/#$1" /dev/null | tee nixos-switch.log || {
  grep --color error nixos-switch.log || true
  echo "Build failed -- not activating."
  read -n 1 -s -r -p "Press any key to continue..." _
  exit 1
}

# Build passed -- choose how to activate. Enter (empty) defaults to switch.
echo
echo "Build OK. Choose activation:"
echo "  [s] switch -- activate now (default)"
echo "  [b] boot   -- activate on next boot"
echo "  [c] cancel -- do nothing"
read -n 1 -s -r -p "Selection [S/b/c] (Enter = switch): " action
echo
case "$action" in
  ""|s|S) mode="switch" ;;
  b|B)    mode="boot" ;;
  *)      echo "Cancelled."; popd; exit 0 ;;
esac

echo "NixOS Rebuilding ($mode)..."

# Rebuild, output simplified errors, log trackebacks
script -qefc "sudo nixos-rebuild $mode --flake ~/nix/#$1" /dev/null | tee -a nixos-switch.log || {
  grep --color error nixos-switch.log || true
  read -n 1 -s -r -p "Press any key to continue..." _
  exit 1
}

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep True)

# Commit all changes witih the generation metadata
git commit -am "$current" || {
  notify-send -e "NixOS Rebult, Git did not generate commit." --icon=software-update-available-symbolic
  read -n 1 -s -r -p "Press any key to continue..." _
  exit 1
}

git push origin main || {
  notify-send -e "NixOS Rebult, Git did not push to orgin main." --icon=software-update-available-symbolic
  read -n 1 -s -r -p "Press any key to continue..." _
  exit 1
}
# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available-symbolic
