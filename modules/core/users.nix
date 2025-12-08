
{ pkgs, ... }:
{
  users.users.jeremy = {
    isNormalUser = true;
    description = "Jeremy McLynch";
    extraGroups = [ "networkmanager" "wheel" "docker" ];

    # Prefer putting user-scoped packages into Home Manager.
    packages = [ ];
  };

  programs.firefox.enable = true;
}
