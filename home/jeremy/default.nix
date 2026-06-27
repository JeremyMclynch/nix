
{ hostName ? "desktop", ... }:
{
  imports = [
    ./common.nix
    (if hostName == "laptop" then ./laptop.nix
     else if hostName == "nixos-rog" then ./rog.nix
     else ./desktop.nix)
  ];
}
