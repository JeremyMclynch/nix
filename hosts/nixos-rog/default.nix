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

  services.hardware.bolt.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Reduce shutdown hang time — default 90s is too long if a FUSE mount is busy
  systemd.settings.Manager.DefaultTimeoutStopSec = "15s";

  # Lazy-unmount user FUSE mounts (gvfsd, xdg-desktop-portal) before systemd-shutdown
  # pivots to the initramfs. They remain open even from a TTY because GDM keeps the
  # user@1000 session partially alive; without this they block the final unmount of /run.
  systemd.services.pre-shutdown-fuse-umount = {
    description = "Lazy-unmount user FUSE mounts before shutdown";
    # DefaultDependencies=yes (the default) silently adds Conflicts=shutdown.target,
    # which wins over WantedBy=shutdown.target and prevents the service from running.
    unitConfig.DefaultDependencies = "no";
    wantedBy = [ "shutdown.target" "reboot.target" "halt.target" ];
    before   = [ "shutdown.target" "reboot.target" "halt.target" ];
    # Run after the user session stops so the FUSE daemons are dead and lazy-umount
    # can fully detach the mounts before systemd-shutdown pivots to the initramfs.
    after    = [ "user@1000.service" "user-runtime-dir@1000.service" ];
    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;
      ExecStart       = "/run/current-system/sw/bin/sh -c 'umount -l /run/user/*/gvfs /run/user/*/doc 2>/dev/null; true'";
    };
  };

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
