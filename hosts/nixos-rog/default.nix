{ inputs, lib, options, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../roles/rog.nix

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

    ../../modules/dev/environment.nix
  ];

  networking.hostName = "nixos-rog";

  programs.nix-ld.enable = true;
  fonts.fontDir.enable = true;

  virtualisation.docker.enable = true;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [
    linux-firmware
    sof-firmware
  ];

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    GDK_SCALE = "1.6";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  qt.platformTheme = "qt5ct";

  services.openssh.enable = true;
  services.upower.enable = true;
  services.flatpak.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]

    MatchUdevType=keyboard
    MatchName=keyd*keyboard
    AttrKeyboardIntegration=internal
  '';

  programs.neovim.enable = true;
  documentation.dev.enable = true;


  environment.systemPackages = with pkgs; [
    wget
    neovim
    vivaldi
    git
    nmap
    debootstrap
    xhost
    docker
    darkly
    adwaita-icon-theme
    alsa-utils
    sof-firmware
    alsa-ucm-conf
    bluetui
    networkmanagerapplet
    networkmanager-openconnect
    libinput
    wofi
    screen
  ];

  system.stateVersion = "25.11";
}
