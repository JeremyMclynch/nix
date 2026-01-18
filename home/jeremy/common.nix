
{ pkgs, config, inputs, lib, ... }:
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
  gtk = {
      enable = true;
      #theme.name = "Adwaita";
      #cursorTheme.name = "Bibata-Modern-Ice";
      #iconTheme.name = "GruvboxPlus";
      #theme.package = pkgs.gnome-themes-extra;
      iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
    };

  programs.neovim.enable = true;
  programs.bash.enable = true;

programs.vesktop = {
    enable = true;

    vencord.settings = {
      autoUpdate = true;
      autoUpdateNotification = true;
      notifyAboutUpdates = true;

      plugins = {
        ClearURLs.enabled = true;
        FixYoutubeEmbeds.enabled = true;
      };
    };
  };
#  programs.caelestia = {
#      enable = true;
#      settings = {
#          idle = {
#              lockBeforeSleep = true;
#              inhibitWhenAudio = true;
#
#              timeouts = [
#              {
#                  timeout = 180;
#                  idleAction = "lock";
#                }
#                {
#                    timout = 300;
#                    idleAction = "dpms off";
#                    returnAction = "dpms on";
#                  }
#              ];
#            };
#        };
#    };

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
    "Pictures/Wallpapers" = {
        source = ../../Wallpapers;
        recursive = true;
    };
    ".local/state/caelestia" = {
        source = ../../dots/caelestia/state/caelestia;
        recursive = true;
    };
 };



  imports = [
    ./packages.nix
    ./caelestia.nix
  ];
}
