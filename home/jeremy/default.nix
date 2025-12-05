
{ hostName ? "desktop", ... }:
{
  imports = [
    ./common.nix
    (if hostName == "laptop" then ./laptop.nix else ./desktop.nix)
  ];
}
