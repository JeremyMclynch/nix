
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # frequently used CLI tools
    neofetch
    nnn

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep
    jq
    yq-go
    eza
    fzf

    # networking tools
    mtr
    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    fish

    # nix related
    nix-output-monitor

    # productivity
    hugo
    glow

    # monitoring
    btop
    iotop
    iftop

    # syscall / process inspection
    strace
    ltrace
    lsof

    # system-ish tools also okay in HM (you may additionally have these system-wide)
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    hyprpicker
    wl-clipboard
    cliphist
    bluez
    bluez-tools
    inotify-tools
    app2unit
    wireplumber
    trash-cli
    foot
    fish
    fastfetch
    starship
    btop
    jq
    socat
    imagemagick
    curl
    adw-gtk3
    papirus-icon-theme
    kdePackages.qt6ct
    libsForQt5.qt5ct
    nerd-fonts.jetbrains-mono
    pavucontrol
    zoxide
    gcc
    lxqt.pavucontrol-qt
    slack
    discord
    nemo
    xclip
    obsidian
    remmina
    vscode
    zoom
  ];
}
