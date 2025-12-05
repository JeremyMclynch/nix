
{ lib, ... }:
{
  imports = [
    ../modules/power/desktop-performance.nix
  ];

  # Desktop default: ignore lid switch if present
  services.logind.lidSwitch = lib.mkDefault "ignore";
}
