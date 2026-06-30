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

    ../../modules/dev/environment.nix
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
    settings.X11Forwarding = true;
  };

  services.upower.enable = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startxfce4";
  services.xrdp.openFirewall = true;

  services.sysstat.enable = true;

  services.udev = {
    packages = with pkgs; [
      qmk
      qmk-udev-rules
      qmk_hid
      via
    ];
    extraRules = ''
    ACTION=="add", SUBSYSTEM=="sound", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="008c", ENV{ELGATO_LOOPBACK}="1", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="capture-card-loopback.service"
    ACTION=="remove", SUBSYSTEM=="sound", ENV{ELGATO_LOOPBACK}=="1", RUN+="${pkgs.systemd}/bin/systemctl --user --machine=jeremy@ stop capture-card-loopback.service"
    '';
  };

  environment.variables = {
    GDK_SCALE = "1";
#    AQ_DRM_DEVICES = "/dev/dri/card2";
  };

  services.flatpak.enable = true;

  documentation.dev.enable = true;

  programs.steam = {
    enable = true;
    extest.enable = true;
    extraPackages = [ pkgs.hidapi ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  hardware.steam-hardware.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

#  services.displayManager.sessionPackages = [
#    (pkgs.runCommand "gamescope-session" {
#      passthru.providedSessions = [ "gamescope-session" ];
#    } ''
#      mkdir -p $out/share/wayland-sessions
#      cat > $out/share/wayland-sessions/gamescope-session.desktop <<EOF
#      [Desktop Entry]
#      Name=Gamescope (HDR Gaming)
#      Comment=Steam Big Picture on OLED via dGPU
#      Exec=env WLR_DRM_DEVICES=/dev/dri/card1 MESA_VK_DEVICE_SELECT=1002:744c gamescope --backend drm --prefer-output DP-1 -W 2560 -H 1440 -r 240 --hdr-enabled --adaptive-sync --steam --expose-wayland --force-grab-cursor -- steam -tenfoot -gamepadui -steamos3 -steampal
#      Type=Application
#      DesktopNames=gamescope
#      EOF
#    '')
#  ];

systemd.user.services.capture-card-loopback = {
  description = "Loopback Elgato capture card audio to FiiO K3";
  after = [ "pipewire.service" ];
  serviceConfig = {
    ExecStart = ''
      ${pkgs.pipewire}/bin/pw-loopback \
        --capture-props=node.target=alsa_input.usb-Elgato_Elgato_Game_Capture_Neo_ABAMB5131042KX-02.analog-stereo \
        --playback-props=node.target=alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_K3-00.analog-stereo
    '';
    Restart = "on-failure";
    RestartSec = 2;
  };
};

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    keyboard.qmk.enable = true;
  };

  # boot.kernelParams = [
  #   "video=DP-1:2560x1440@240"
  #   "video=DP-2:2560x1440@180"
  # ];

  programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    neovim
    chromium
    git
    #quartus-prime-lite
    debootstrap
    xhost
    docker
    podman
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
    wofi
    lutris
    # rpcs3  # upstream build broken: undefined reference to __glewXSwapIntervalEXT in GLGSRender
    #discord
    #kicad
    mkosi
  ];

  system.stateVersion = "25.11";
}
