{ pkgs, config, inputs, lib, ... }:

{
  home.username = "jeremy";
  home.homeDirectory = "/home/jeremy";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "Jeremy McLynch";
      email = "admin@jmclynch.org";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  #home.pointerCursor = {
  #  name = "Dracula-cursors";
  #  package = pkgs.dracula-theme;
  #  size = 24;
  #  gtk.enable = true;
  #  x11.enable = true;
  #};

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # Tells libadwaita apps (Nautilus, etc.) and xdg-desktop-portal (Firefox) to use dark mode
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";


  programs.bash = {
    enable = true;
    initExtra = ''
      eval -- "$(/etc/profiles/per-user/jeremy/bin/starship init bash --print-full-init)"
      
      export PATH="$PATH:$HOME/.bin"

      if [ "$(hostname)" == "nixos-desktop" ]; then
        export systemname="desktop"
      else
        export systemname="laptop"
      fi

      if [ -f ~/.config/exercism/exercism_completion.bash ]; then               
        source ~/.config/exercism/exercism_completion.bash                      
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
    # Suppress GNOME's standalone polkit agent in non-GNOME (Hyprland) sessions.
    # uwsm activates xdg-desktop-autostart.target, which launches the system
    # /etc/xdg/autostart entries -- including polkit-gnome-authentication-agent-1
    # (its AutostartCondition runs it in every session *except* GNOME). It would
    # grab the org.freedesktop.PolicyKit1 authentication-agent slot before
    # noctalia (whose own agent we use: shell.polkit_agent = true), giving the
    # old GTK auth dialog. A user-level autostart entry of the same name with
    # Hidden=true overrides the system one and the xdg-autostart generator skips
    # it. Harmless in a GNOME session -- gnome-shell has its own built-in agent
    # and that condition already disabled this one there anyway.
    ".config/autostart/polkit-gnome-authentication-agent-1.desktop".text = ''
      [Desktop Entry]
      Hidden=true
    '';
    # Hyprland Lua API type stubs (defines the `hl` global) for lua_ls.
    # Referenced by dots/hypr/.luarc.json so neovim/LazyVim recognizes `hl`
    # and offers completion. Tracks the current Hyprland version automatically.
    ".config/hypr/stubs".source = "${pkgs.hyprland}/share/hypr/stubs";
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
    #./caelestia.nix
  ];
}
