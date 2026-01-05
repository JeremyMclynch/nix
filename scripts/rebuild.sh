#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "No Argument given, exiting..."
  exit 1
fi
# cd to your config dir
pushd ~/nix/

# Early return if no changes were detected
if [ -z "$(git diff)" ] && [ "$(git pull)" = "Already up to date." ]; then
  echo "No changes detected, exiting."
  popd
  exit 0
fi

# Shows your changes
git diff -U0

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch --flake ~/nix/#"$1" &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep True)

# Commit all changes witih the generation metadata
git commit -am "$current"
git push origin main || notify-send -e "NixOS Rebult, Git did not push to orgin main."
# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
