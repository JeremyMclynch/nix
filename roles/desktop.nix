
{ lib, pkgs, ... }:
{
  imports = [
    ../modules/power/desktop-performance.nix
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

  # Desktop default: ignore lid switch if present
  services.logind.settings.Login.HandleLidSwitch = lib.mkDefault "ignore";
}
