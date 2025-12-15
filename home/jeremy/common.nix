
{ pkgs, config, ... }:
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
  dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
 # gtk = {
 #     enable = true;
 #     theme.name = "Adwaita-dark";
 #     #cursorTheme.name = "Bibata-Modern-Ice";
 #     #iconTheme.name = "GruvboxPlus";
 #     theme.package = pkgs.gnome-themes-extra;
 #   };

  programs.neovim.enable = true;
  programs.bash.enable = true;

  #qt.style.package = with pkgs; [ darkly-qt5 darkly ];
  #qt.platformTheme.name = "qtct";
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
    ".config/uwsm" = {
      source = ../../dots/uwsm;
      recursive = true;
      executable = true; # Makes all files in the linked directory executable
    };
    ".config/starship.toml" = {
      source = ../../dots/starship.toml;
      recursive = true;
      executable = true; # Makes all files in the linked directory executable
    };
    ".config/thunar" = {
      source = ../../dots/thunar;
      recursive = true;
      executable = true; # Makes all files in the linked directory executable
    };
    ".config/qt5ct" = {
      source = ../../dots/qt;
      recursive = true;
      executable = true; # Makes all files in the linked directory executable
    };
    ".config/qt6ct" = {
      source = ../../dots/qt;
      recursive = true;
      executable = true; # Makes all files in the linked directory executable
    };
 };



  imports = [
    ./packages.nix
    ./caelestia.nix
  ];
}
