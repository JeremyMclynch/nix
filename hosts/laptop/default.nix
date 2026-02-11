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

  #fonts.packages = with pkgs; [ nerd-fonts.caskaydia-cove ];

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
      #GDK_DPI_SCALE = "0.5";
      QT_QPA_PLATFORMTHEME="qt5ct";
    };
#environment.systemPackages = with pkgs; [ darkly-qt5 darkly ];
qt.platformTheme = "qt5ct";

services.openssh.enable = true;
services.upower.enable = true;
services.flatpak.enable = true;
#  virtualisation = {
#  containers.enable = true;
#  #docker.enable = true;
#  podman = {
#    enable = true;
#    dockerCompat = true;
#    defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
#  };
#};
 

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
    wofi

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
