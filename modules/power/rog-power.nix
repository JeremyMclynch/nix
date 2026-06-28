{ pkgs, ... }:
{
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = [ pkgs.brightnessctl ];
}
