#!/usr/bin/env bash
# Toggle HDR for the Hyprland *Lua* config.
# Mirrors scripts/hdr.sh but swaps Lua monitor files and targets a separate
# current file (hdr-current.lua), so the legacy hdr-current.conf used by the
# current session is left untouched.

HDR_LINK=~/.config/hypr/hdr-current.lua

if grep -qE 'cm[[:space:]]*=[[:space:]]*"hdr"' "$HDR_LINK" 2>/dev/null; then
    cp ~/nix/scripts/hdr-config/hdr-off.lua "$HDR_LINK"
else
    cp ~/nix/scripts/hdr-config/hdr-on.lua "$HDR_LINK"
fi
hyprctl reload
