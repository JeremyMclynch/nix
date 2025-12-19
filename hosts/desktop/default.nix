
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

  ];

  programs.nix-ld.enable = true;
  fonts.fontDir.enable = true;

  networking.hostName = "nixos-desktop";

  virtualisation.docker = {
  enable = true;
  };
  qt.platformTheme = "qt5ct";

  services.openssh.enable = true;

services.udev = {
    packages = with pkgs; [
      qmk
      qmk-udev-rules
      qmk_hid
      via
    ];
  };

hardware.keyboard.qmk.enable = true;
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
    steam

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
