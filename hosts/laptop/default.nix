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
    ../../modules/desktop/noctalia-greeter.nix
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

  networking.hostName = "nixos-laptop";

  programs.nix-ld.enable = true;
  fonts.fontDir.enable = true;

  virtualisation = {
    #vmware.host.enable = true;
    docker = {
      enable = true;
      # Move Docker off its default 172.17.0.0/16 bridge so it can't collide
      # with a LAN in the 172.16.0.0/12 range. On such a network docker0's
      # default 172.17.0.1/16 overlaps the real subnet/gateway, the kernel
      # treats that space as local to docker0, stops answering the gateway's
      # ARP, and the connection blackholes in ~30s cycles. Relocate the bridge
      # (bip) and the user/compose network pool to 10.x. (Same fix as the
      # desktop host.)
      daemon.settings = {
        bip = "10.200.0.1/24";
        default-address-pools = [
          { base = "10.201.0.0/16"; size = 24; }
        ];
      };
    };
  };

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  hardware.firmware = with pkgs; [
    linux-firmware
    sof-firmware
  ];

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

#  nixpkgs.config.segger-jlink.acceptLicense = true;
#  nixpkgs.config.permittedInsecurePackages = [
#    "segger-jlink-qt4-874"
#  ];

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]

    MatchUdevType=keyboard
    MatchName=keyd*keyboard
    AttrKeyboardIntegration=internal
  '';


  services.logind.settings.Login.HandlePowerKey = "ignore"; # Ignore power button press for accidental shutdown

  programs.neovim.enable = true;

  documentation.dev.enable = true;


  environment.systemPackages = with pkgs; [
    wget
    neovim
    #vivaldi
    git
    #quartus-prime-lite
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
    #jetbrains.dataspell
    python314
    platformio-core
    platformio
    networkmanagerapplet
    networkmanager-openconnect
    debootstrap
    libinput
    wofi
    #nrfconnect
    #nrf-udev
    #nrf5-sdk
    #nrfutil
    #nrf-command-line-tools
    screen
    rclone
    rclone-browser
  ];

  system.stateVersion = "25.11";
}
