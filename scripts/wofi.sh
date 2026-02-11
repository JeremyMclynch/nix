#!/usr/bin/env bash

set -euo pipefail

cd /home/jeremy/nix/scripts/

if [ "$(hostname)" == "nixos-desktop" ]; then
  systemname="desktop"
else
  systemname="laptop"
fi
nvim="foot -e --title='rebuild' nvim"

DISPLAY_NAMES=("host.nix" "home.nix" "pkg.nix" "config.fish" "hypr.conf" "hypr/rules.conf" "hypr/keybinds.conf" "rebuild" "exit")
COMMANDS=("$nvim ../hosts/${systemname}/default.nix" "$nvim ../home/jeremy/common.nix" "$nvim ../home/jeremy/packages.nix" "$nvim ../dots/fish/config.fish"
  "$nvim ../dots/hypr/hyprland.conf" "$nvim ../dots/hypr/hyprland/rules-noctalia.conf" "$nvim ../dots/hypr/hyprland/keybinds-noctalia.conf" ":" "break")

# Use wofi in dmenu mode, passing the menu items via stdin
# --normal-window is used for non-wayland environments, otherwise may not be needed
CHOICE=$(printf "%s\n" "${DISPLAY_NAMES[@]}" | wofi --show dmenu --prompt "Choose an action")
# Match the selection and run the command
for i in "${!DISPLAY_NAMES[@]}"; do
  if [[ "$CHOICE" != "exit" && "${DISPLAY_NAMES[i]}" == "$CHOICE" ]]; then
    git pull
    eval "${COMMANDS[i]}"
    foot -e --title='rebuild' ../scripts/rebuild.sh "${systemname}" pkexec
    break
  fi
done
