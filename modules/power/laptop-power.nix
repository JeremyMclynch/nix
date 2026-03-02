
{ pkgs, ... }:
{
  # GNOME-friendly power mode switching
  services.power-profiles-daemon.enable = true;

  # Set brightness to 100% on boot
  systemd.services.set-brightness = {
    description = "Set screen brightness to 75% on boot";
    wantedBy = [ "multi-user.target" ]; # Or graphical.target
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.brightnessctl}/bin/brightnessctl set 75%";
    };
  };

  # Ensure brightnessctl is available
  environment.systemPackages = [ pkgs.brightnessctl ];
}
