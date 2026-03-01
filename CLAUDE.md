# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Rebuild for desktop
sudo nixos-rebuild switch --flake .#desktop

# Rebuild for laptop
sudo nixos-rebuild switch --flake .#laptop

# Test configuration without switching
sudo nixos-rebuild test --flake .#desktop

# Build without activating
sudo nixos-rebuild build --flake .#laptop

# Update flake inputs
nix flake update
```

## Architecture

This is a NixOS flake-based configuration managing two hosts (`desktop` and `laptop`) with Home Manager integration.

### Directory Structure

- `flake.nix` - Main entry point defining inputs (nixpkgs, home-manager, caelestia, noctalia) and the `mkHost` helper function
- `hosts/{desktop,laptop}/` - Host-specific configs including `hardware-configuration.nix`
- `roles/` - Role-based configurations (`desktop.nix` for performance settings, `laptop.nix` for power management)
- `modules/` - Reusable NixOS modules organized by category:
  - `core/` - boot, networking, i18n, nix settings, users
  - `desktop/` - gnome, hyprland, printing
  - `services/` - pipewire, tailscale, keyd
  - `power/` - bluetooth, laptop-power, desktop-performance
  - `caelestia/` - Caelestia shell dependencies
  - `noctalia/` - Noctalia shell integration
- `home/jeremy/` - Home Manager configuration with conditional imports based on hostname
- `dots/` - Dotfile configurations symlinked via Home Manager (hypr, fish, foot, fastfetch, btop, etc.)

### Key Patterns

- `mkHost` in `flake.nix` centralizes host creation with Home Manager setup
- `home/jeremy/default.nix` conditionally imports `laptop.nix` or `desktop.nix` based on `hostName`
- External flake inputs (Caelestia CLI/Shell, Noctalia) are passed via `specialArgs` and `extraSpecialArgs`
- Dotfiles in `dots/` are symlinked to `~/.config/` via `home.file`

### Desktop Environments

- GNOME with GDM as the primary session manager
- Hyprland available as an optional session (select via GDM gear icon)
- Caelestia shell can be started with `caelestia shell -d`
