
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
    libnotify
    #hyprpaper
  ];

  # CJK + emoji font coverage so Japanese/Chinese/Korean glyphs render
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
  ];
}
