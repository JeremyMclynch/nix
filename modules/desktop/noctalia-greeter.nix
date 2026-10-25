{ inputs, lib, pkgs, ... }:
{
  # Noctalia greeter as the login screen, replacing GDM.
  # https://docs.noctalia.dev/greeter/installation/?section=nixos-declarative-setup
  #
  # The upstream module pulls in greetd + AccountsService + Polkit and runs the
  # greeter via greetd. GDM is enabled by the shared modules/desktop/gnome.nix,
  # so force it off here. Imported by the desktop and laptop hosts (both run
  # GNOME on GDM); GNOME and Hyprland remain selectable sessions in the greeter's
  # session list.
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  services.displayManager.gdm.enable = lib.mkForce false;

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor = {
        theme = "Adwaita"; # matches dots/hypr/lua/variables.lua (cursorTheme/cursorSize)
        size = 24;
        path = pkgs.adwaita-icon-theme;
      };
    };
  };
}
