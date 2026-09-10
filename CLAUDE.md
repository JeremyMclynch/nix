# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

These are the commands the **user** runs to apply a config (they need sudo):

```bash
# Rebuild + activate (flake attr name -- NOT the hostname)
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild switch --flake .#laptop
sudo nixos-rebuild switch --flake .#nixos-rog

# Test without making it the boot default
sudo nixos-rebuild test --flake .#desktop
```

Note: the flake attribute names (`desktop`, `laptop`, `nixos-rog`) differ from the
runtime `networking.hostName` (`nixos-desktop`, `nixos-laptop`, `nixos-rog`). The
hostname matters for Hyprland's per-host Lua detection (see below).

### Agent guidance (Claude Code)

**Claude Code has no sudo access — never run `sudo`.** Do not run
`nixos-rebuild switch` or `nixos-rebuild test` (both require root). To validate a
change, build without activating and without sudo:

```bash
# Validate a host config evaluates + builds (no root, no activation)
nixos-rebuild build --flake .#desktop
nixos-rebuild build --flake .#nixos-rog

# Or evaluate the toplevel directly
nix build '.#nixosConfigurations.desktop.config.system.build.toplevel' --no-link

# Flake input maintenance (no sudo needed)
nix flake update
nix flake update anipy-cli
```

Leave the actual `sudo nixos-rebuild switch`/`test` to the user. In general, prefer
non-privileged commands only; if a step genuinely needs root, describe it for the
user to run rather than attempting it.

## Architecture

NixOS flake managing three hosts (`desktop`, `laptop`, `nixos-rog`) with Home
Manager integration.

### Directory Structure

- `flake.nix` - inputs (nixpkgs, home-manager, noctalia, anipy-cli + pinned
  nixpkgs-anipy; Caelestia inputs are commented out) and the `mkHost` helper.
- `hosts/{desktop,laptop,nixos-rog}/` - host configs incl. `hardware-configuration.nix`
  and `networking.hostName`.
- `roles/` - `desktop.nix`, `laptop.nix`, `rog.nix` (kernel/power/lid defaults per class).
- `modules/` - reusable NixOS modules:
  - `core/` - boot, networking, i18n, nix, users
  - `desktop/` - gnome (GDM), kde (SDDM), hyprland, printing
  - `services/` - audio-pipewire, tailscale, keyd
  - `power/` - bluetooth, laptop-power, desktop-performance, rog-power
  - `asus/` - rog.nix (asusd/supergfxd etc. for the Zephyrus)
  - `dev/` - environment, toolchains (also feeds the flake devShell)
  - `noctalia/` - Noctalia shell integration; `caelestia/` - Caelestia deps (legacy)
- `home/jeremy/` - Home Manager; `default.nix` branches to `rog.nix` / `laptop.nix`
  / `desktop.nix` by `hostName`, all importing `common.nix`.
- `dots/` - dotfiles symlinked into `~/.config/` via `home.file` (hypr, fish, foot,
  fastfetch, btop, etc.).

### Key Patterns

- `mkHost` in `flake.nix` centralizes host creation; passes `hostName = <flake attr>`
  via `specialArgs`/`extraSpecialArgs`.
- External inputs (Noctalia, anipy-cli) reach modules through those specialArgs.
- Dotfiles in `dots/` are symlinked to `~/.config/` (see `home/jeremy/common.nix`);
  the whole `dots/hypr` tree is symlinked **identically on every host**.

### Sessions

- desktop & nixos-rog: GNOME on GDM (primary), Hyprland optional (GDM gear icon).
- laptop: KDE Plasma on SDDM (primary), Hyprland optional.
- All hosts import `modules/desktop/hyprland.nix` (`programs.hyprland`).

## Hyprland (Lua config -- 0.55+)

Hyprland 0.55 replaced hyprlang `.conf` with Lua. This repo is fully converted.

- **Entry point:** `dots/hypr/hyprland.lua` -- `require`s the modules under
  `dots/hypr/lua/` in apply order:
  `env → monitors → (pcall hdr-current) → general → input → misc → animations →
  decoration → group → gestures → execs → rules → binds`.
- **Modules (`dots/hypr/lua/`):** `colors` (palette, mirrors `scheme/current.conf`),
  `variables` (shared styling values), `env` (env vars + xwayland), `monitors`,
  `general`, `decoration`, `animations`, `input` (+`hl.device`), `misc`, `group`,
  `gestures`, `execs` (autostart), `rules` (window/layer/workspace), `binds`
  (all keybinds; `$`-vars dereferenced to literal chords).
- **The `hl` global API:** `hl.config({...})` (nested settings), `hl.env(k,v)`,
  `hl.monitor{...}`, `hl.bind("MOD + KEY", hl.dsp.<area>.<action>(...))`,
  `hl.dsp.exec_cmd(cmd)`, `hl.on("hyprland.start", fn)` + `hl.exec_cmd(cmd)`,
  `hl.curve`/`hl.animation`, `hl.window_rule`/`hl.layer_rule`/`hl.workspace_rule`,
  `hl.define_submap`, `hl.gesture`, `hl.device`.

### Per-host behavior (important)

`dots/hypr` is symlinked byte-for-byte to every host, so there is **no** per-host
Nix templating of the Lua. Host-specific behavior is decided **at runtime** by
reading `/etc/hostname` (which equals `networking.hostName`). Example in
`lua/env.lua`: only when hostname is `nixos-rog` does it set `AQ_NO_ATOMIC=1`,
`WLR_NO_HARDWARE_CURSORS=1`, and `cursor.no_hardware_cursors` (GPU/cursor
workarounds the ROG needs to start Hyprland). Add future per-host tweaks the same
way. Note: `hl.env(...)` only takes effect on a fresh Hyprland launch, not
`hyprctl reload`; `hl.config` settings do apply on live reload.

### Autostart ordering (`lua/execs.lua`)

hypridle and noctalia both try to own the `org.freedesktop.ScreenSaver` D-Bus name
(where Firefox/mpv send "media playing" idle inhibits) and the first to claim it
keeps it. `execs.lua` therefore starts **hypridle first, waits until it owns the
name, then starts noctalia** (which falls back to logind idle-inhibit monitoring).
Reordering this reintroduces the "screen locks during video" bug.

### Not Lua / left as-is

- `dots/hypr/hypridle.conf` - config for the **hypridle** daemon, not Hyprland.
- `dots/hypr/scheme/*.conf` - color palette source (its data lives in `lua/colors.lua`).
- `hdr-current` - optional runtime file at `~/.config/hypr/hdr-current.lua`; loaded
  via `pcall` so its absence (e.g. on laptops) is harmless.

### Editor support & verification

`dots/hypr/.luarc.json` points lua_ls at `~/.config/hypr/stubs` (symlinked from
`${pkgs.hyprland}/share/hypr/stubs` in `common.nix`) so the `hl` global resolves.

Validate before switching (all non-sudo):

```bash
# 1. Lua syntax/parse check for every module + the entry point
#    (luac/xxd are not installed; use nixpkgs#lua's loadfile)
for f in dots/hypr/hyprland.lua dots/hypr/lua/*.lua; do
  nix run nixpkgs#lua -- -e "assert(loadfile('$f'))" \
    && echo "OK: $f" || echo "FAIL: $f"
done

# 2. Full Hyprland config validation (schema-aware) -> prints "config ok"
Hyprland --verify-config --config dots/hypr/hyprland.lua

# 3. On a running Hyprland session, apply the live symlinked config
hyprctl reload            # note: hl.env() needs a fresh launch, not reload
hyprctl version           # confirm the running Hyprland version (0.55.x -> Lua)
hyprctl configerrors      # list any errors from the currently loaded config
```

## Notes

- `anipy-cli` is pinned to its own nixpkgs via the `nixpkgs-anipy` input (its
  bundled poetry2nix fork won't build against current nixos-unstable). Update it
  with `nix flake update anipy-cli`; don't re-point it at the main `nixpkgs`.
- `nix develop` provides a multi-language devShell (see `modules/dev/toolchains.nix`);
  `nix flake init -t .#<cpp|rust|go|python|node>` scaffolds per-language shells.
