#!/usr/bin/env bash
  HDR_LINK=~/.config/hypr/hdr-current.conf

  if grep -q "cm = hdr" "$HDR_LINK" 2>/dev/null; then
      cp ~/nix/scripts/hdr-config/hdr-off.conf "$HDR_LINK"
  else
      cp ~/nix/scripts/hdr-config/hdr-on.conf "$HDR_LINK"
  fi
  hyprctl reload
