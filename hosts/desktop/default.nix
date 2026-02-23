
{ inputs, lib, options, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../roles/desktop.nix


    ../../modules/core/boot.nix
    ../../modules/core/networking.nix
    ../../modules/core/i18n.nix
    ../../modules/core/nix.nix
    ../../modules/core/users.nix

    ../../modules/desktop/gnome.nix
    ../../modules/desktop/printing.nix
    ../../modules/desktop/hyprland.nix

    ../../modules/services/audio-pipewire.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/keyd.nix

    ../../modules/caelestia/deps.nix

    ../../modules/power/bluetooth.nix
    ../../modules/noctalia/noctalia.nix
  ];

  programs.nix-ld.enable = true;
  fonts.fontDir.enable = true;

  networking.hostName = "nixos-desktop";

  virtualisation.docker = {
  enable = true;
  };
  qt.platformTheme = "qt5ct";

  services.openssh = {
    enable = true;
    forwardX11 = true;
  };
  services.upower.enable = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;


# Use the GNOME Wayland session
services.xserver.enable = true;
services.xserver.desktopManager.xfce.enable = true;
services.xrdp.enable = true;
services.xrdp.defaultWindowManager = "startxfce4";
# Open the default RDP port (3389)
services.xrdp.openFirewall = true;

services.sysstat.enable = true;

services.udev = {
    packages = with pkgs; [
      qmk
      qmk-udev-rules
      qmk_hid
      via
    ];
  };

  environment.variables = {
      GDK_SCALE = "1";
      #GDK_DPI_SCALE = "0.5";
    };

services.flatpak.enable = true;

programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
programs.gamescope = {
  enable = true;
  capSysNice = false;
};
  hardware = {
      graphics = {
          enable = true;
          enable32Bit = true;
        };
      keyboard.qmk.enable = true;
    };
  #boot.kernelParams = [
  #  "video=DP-1:2560x1440@240"
  #  "video=DP-2:2560x1440@180"
  #];
  # Your original host-level packages (system-wide)
  environment.systemPackages = with pkgs; [
    wget
    neovim
    vivaldi
    git
    quartus-prime-lite
    debootstrap
    xhost
    docker
    podman
    darkly-qt5
    darkly
    adwaita-icon-theme
    bluetui
    via
    winboat
    gamescope-wsi
    networkmanager-openconnect
    webkitgtk_4_1
    libnma-gtk4
    python314
    networkmanagerapplet
    debootstrap
    apptainer
    lutris
    wofi
    rpcs3
    discord

    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSEnv (base // {
      name = "fhs";
      targetPkgs = pkgs:
        # pkgs.buildFHSEnv provides only a minimal FHS environment,
        # lacking many basic packages needed by most software.
        # Therefore, we need to add them manually.
        #
        # pkgs.appimageTools provides basic packages required by most software.
        (base.targetPkgs pkgs) ++ (with pkgs; [
          pkg-config
          ncurses
          # Feel free to add more packages here if needed.
        ]
      );
      profile = "export FHS=1";
      runScript = "bash";
      extraOutputsToInstall = ["dev"];
    }))

  ];

  system.stateVersion = "25.11";
}
