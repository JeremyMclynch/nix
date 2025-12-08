
{ pkgs, ... }:
{
  home.username = "jeremy";
  home.homeDirectory = "/home/jeremy";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Jeremy McLynch";
    userEmail = "admin@jmclynch.org";
  };
  gtk = {
      enable = true;
      theme.name = "adw.gtk3";
      cursorTheme.name = "Bibata-Modern-Ice";
      iconTheme.name = "GruvboxPlus";
    };

  programs.neovim.enable = true;
  programs.bash.enable = true;

 # home.file = {
 #       # Example 1: Symlink a file from your dotfiles directory to a specific location
 #       ".config/my-app/config.conf" = {
 #         source = ./dotfiles/my-app/config.conf;
 #         # Optional: Make the symlink executable if it's a script
 #         # executable = true;
 #       };
 
 home.file = {
    ".config/hypr" = {
      source = ../../dots/hypr;
      recursive = true;
      executable = true; # Makes all files in the linked directory executable
    };
    ".config/fish" = {
      source = ../../dots/fish;
      recursive = true;
      executable = true; # Makes all files in the linked directory executable
    };
    ".config/foot" = {
      source = ../../dots/foot;
      recursive = true;
      executable = true; # Makes all files in the linked directory executable
    };
    ".config/fastfetch" = {
      source = ../../dots/fastfetch;
      recursive = true;
      executable = true; # Makes all files in the linked directory executable
    };
    ".config/btop" = {
      source = ../../dots/btop;
      recursive = true;
      executable = true; # Makes all files in the linked directory executable
    };
    ".local/share/fonts" = {
        source = ../../fonts
        recursive = true;
      } 
  };

  imports = [
    ./packages.nix
    ./caelestia.nix
  ];
}
