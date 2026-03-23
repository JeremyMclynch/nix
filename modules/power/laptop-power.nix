
{ pkgs, ... }:
{
  # GNOME-friendly power mode switching
  services.power-profiles-daemon.enable = true;

  # Set brightness to 100% on boot
  systemd.services.set-brightness = {
    description = "Set screen brightness to 75% on boot";
    wantedBy = [ "graphical.target" ]; # Or multi-user.target
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.brightnessctl}/bin/brightnessctl set 144000 -d intel_backlight && ${pkgs.brightnessctl}/bin/brightnessctl get -d intel_backlight";
    };
  };

  # Ensure brightnessctl is available
  environment.systemPackages = [ pkgs.brightnessctl ];
}
