
{ pkgs, ... }:
{
  imports = [
    #./hyprland.nix
  ];

  # laptop-only extras (optional)
  home.packages = with pkgs; [
    powertop
  ];
}
