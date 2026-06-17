#!/usr/bin/env bash
set -e


speed=$(speedtest-cli | grep -E "Download|Upload")

notify-send -e "${speed}" 

## Early return if no changes were detected
#udo nixos-rebuild switch --flake ~/nix/#"$1" &>nixos-switch.log || (cat nixos-switch.log | grep --color error &&
#  read -n 1 -s -r -p "Press any key to continue..." _ && exit 1)
#
## Get current generation metadata
#current=$(nixos-rebuild list-generations | grep True)
#
## Commit all changes witih the generation metadata
#git commit -am "$current" || (notify-send -e "NixOS Rebult, Git did not generate commit." --icon=software-update-available-symbolic && read -n 1 -s -r -p "Press any key to continue..." _ && exit 1)
#
#git push origin main || (notify-send -e "NixOS Rebult, Git did not push to orgin main." --icon=software-update-available-symbolic && read -n 1 -s -r -p "Press any key to continue..." _ && exit 1)
## Back to where you were
#popd
#
## Notify all OK!
#notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available-symbolic
