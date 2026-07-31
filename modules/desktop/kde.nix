{ pkgs, ... }:
{
  # KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # SDDM display manager (replaces GDM)
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha-mauve";
    wayland.enable = true;
  };

  environment.systemPackages = [ 
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
  ];

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
