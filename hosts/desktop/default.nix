
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

  services.openssh.enable = true;
  services.upower.enable = true;

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

programs.steam = {
    enable = true;
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
