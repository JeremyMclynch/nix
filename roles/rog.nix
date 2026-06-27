{ lib, pkgs, ... }:
{
  imports = [
    ../modules/power/laptop-power.nix
    ../modules/power/rog-power.nix
    ../modules/asus/rog.nix
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  powerManagement.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch              = lib.mkDefault "suspend";
    HandleLidSwitchExternalPower = lib.mkDefault "suspend";
    HandleLidSwitchDocked        = lib.mkDefault "suspend";
  };
}
