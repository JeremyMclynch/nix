
# nixos-config (flake + home-manager)

This repo contains two NixOS hosts:
- `desktop`
- `laptop`

It also includes GNOME + GDM, and adds Hyprland as an additional session you can select in GDM.

## Quick start

1) Copy this folder somewhere (e.g. `/etc/nixos/nixos-config`) or clone it into a repo.

2) Replace *each* host's `hardware-configuration.nix` with the one generated on that machine:
   - `hosts/desktop/hardware-configuration.nix`
   - `hosts/laptop/hardware-configuration.nix`

   You can generate it with:
   ```bash
   sudo nixos-generate-config --show-hardware-config
   ```

3) Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#desktop
   # or
   sudo nixos-rebuild switch --flake .#laptop
   ```

## Selecting Hyprland in GDM
On the GDM login screen, click the gear icon and choose `Hyprland`.

## Caelestia
Caelestia CLI/Shell are installed via flake inputs and Home Manager. After login you can try:
```bash
caelestia shell -d
```

If you later want Caelestia to auto-start in Hyprland, uncomment the relevant `exec-once` line in:
`home/jeremy/hyprland.nix`.
