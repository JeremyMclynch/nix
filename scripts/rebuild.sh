#!/usr/bin/env bash
set -e

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

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch --flake ~/nix/#"$1" &>nixos-switch.log || (cat nixos-switch.log | grep --color error &&
  read -n 1 -s -r -p "Press any key to continue..." _ && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep True)

# Commit all changes witih the generation metadata
git commit -am "$current" || (notify-send -e "NixOS Rebult, Git did not generate commit." --icon=software-update-available-symbolic && read -n 1 -s -r -p "Press any key to continue..." _ && exit 1)

git push origin main || (notify-send -e "NixOS Rebult, Git did not push to orgin main." --icon=software-update-available-symbolic && read -n 1 -s -r -p "Press any key to continue..." _ && exit 1)
# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available-symbolic
