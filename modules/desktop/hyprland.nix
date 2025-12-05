
{ pkgs, ... }:
{
  # Adds Hyprland as an extra session in GDM (GNOME remains available).
  programs.hyprland = {
    enable = true;
    #withUWSM = true;
    xwayland.enable = true;
  };

  # Portals for screenshots/screencast/file pickers
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  # Handy basics for first login to Hyprland
  environment.systemPackages = with pkgs; [
    kitty
    #waybar
    wofi
    #hyprpaper
  ];
}
