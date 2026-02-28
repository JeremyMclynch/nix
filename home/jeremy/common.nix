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
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  programs.neovim.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      eval -- "$(/etc/profiles/per-user/jeremy/bin/starship init bash --print-full-init)"
      if [ "$(hostname)" == "nixos-desktop" ]; then
        export systemname="desktop"
      else
        export systemname="laptop"
      fi
    '';
  };

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

  # programs.caelestia = {
  #   enable = true;
  #   settings = {
  #     idle = {
  #       lockBeforeSleep = true;
  #       inhibitWhenAudio = true;
  #       timeouts = [
  #         {
  #           timeout = 180;
  #           idleAction = "lock";
  #         }
  #         {
  #           timeout = 300;
  #           idleAction = "dpms off";
  #           returnAction = "dpms on";
  #         }
  #       ];
  #     };
  #   };
  # };

  home.file = {
    ".config/hypr" = {
      source = ../../dots/hypr;
      recursive = true;
      executable = true;
    };
    ".config/fish" = {
      source = ../../dots/fish;
      recursive = true;
      executable = true;
    };
    ".config/foot" = {
      source = ../../dots/foot;
      recursive = true;
      executable = true;
    };
    ".config/fastfetch" = {
      source = ../../dots/fastfetch;
      recursive = true;
      executable = true;
    };
    ".config/btop" = {
      source = ../../dots/btop;
      recursive = true;
      executable = true;
    };
    ".config/uwsm" = {
      source = ../../dots/uwsm;
      recursive = true;
      executable = true;
    };
    ".config/starship.toml" = {
      source = ../../dots/starship.toml;
      recursive = true;
      executable = true;
    };
    ".config/thunar" = {
      source = ../../dots/thunar;
      recursive = true;
      executable = true;
    };
    ".config/qt5ct" = {
      source = ../../dots/qt;
      recursive = true;
      executable = true;
    };
    ".config/qt6ct" = {
      source = ../../dots/qt;
      recursive = true;
      executable = true;
    };
    ".config/wofi" = {
      source = ../../dots/wofi;
      recursive = true;
      executable = true;
    };
    "Pictures/Wallpapers" = {
      source = ../../Wallpapers;
      recursive = true;
    };
    ".local/state/caelestia" = {
      source = ../../dots/caelestia/state/caelestia;
      recursive = true;
    };
    ".local/share/applications/Matlab.desktop" = {
      source = ../../scripts/Matlab.desktop;
    };
  };

  imports = [
    ./packages.nix
    ./caelestia.nix
  ];
}
