
{ lib, ... }:
{
  imports = [
    ../modules/power/laptop-power.nix
  ];

  # Laptop-friendly defaults
  powerManagement.enable = true;
  services.upower.enable = true;

  services.logind.settings.Login = {
  HandleLidSwitch = lib.mkDefault "suspend"; # or hybernate
  HandleLidSwitchExternalPower = lib.mkDefault "suspend"; #"ignore";
  HandleLidSwitchDocked = lib.mkDefault "suspend";
  };
}
