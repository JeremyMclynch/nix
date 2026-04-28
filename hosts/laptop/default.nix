{ inputs, lib, options, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../roles/laptop.nix

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

  networking.hostName = "nixos-laptop";

  programs.nix-ld.enable = true;
  fonts.fontDir.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  hardware.firmware = with pkgs; [
    linux-firmware
    sof-firmware
  ];

  environment.sessionVariables = {
    GDK_SCALE = "1.6";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  qt.platformTheme = "qt5ct";

  services.openssh.enable = true;
  services.upower.enable = true;
  services.flatpak.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # virtualisation = {
  #   containers.enable = true;
  #   podman = {
  #     enable = true;
  #     dockerCompat = true;
  #     defaultNetwork.settings.dns_enabled = true;
  #   };
  # };

  nixpkgs.config.segger-jlink.acceptLicense = true;
  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-874"
  ];

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]

    MatchUdevType=keyboard
    MatchName=keyd*keyboard
    AttrKeyboardIntegration=internal
  '';

  environment.systemPackages = with pkgs; [
    wget
    neovim
    vivaldi
    git
    quartus-prime-lite
    nmap
    debootstrap
    xhost
    docker
    darkly-qt5
    darkly
    adwaita-icon-theme
    alsa-utils
    sof-firmware
    alsa-ucm-conf
    bluetui
    jetbrains.dataspell
    python314
    platformio-core
    platformio
    networkmanagerapplet
    networkmanager-openconnect
    debootstrap
    libinput
    wofi
    nrfconnect
    nrf-udev
    nrf5-sdk
    nrfutil
    nrf-command-line-tools
    screen

    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSEnv (base // {
        name = "fhs";
        targetPkgs = pkgs:
          (base.targetPkgs pkgs) ++ (with pkgs; [
            pkg-config
            ncurses
          ]);
        profile = "export FHS=1";
        runScript = "bash";
        extraOutputsToInstall = [ "dev" ];
      }))
  ];

  system.stateVersion = "25.11";
}
