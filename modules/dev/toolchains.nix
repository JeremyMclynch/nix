{ pkgs }:

rec {
  cToolchain = with pkgs; [
    gcc
    clang
    clang-tools
    cmake
    gnumake
    ninja
    meson
    pkg-config
    gdb
    lldb
    valgrind
    bear
    readline
    ncurses
  ];

  rustToolchain = with pkgs; [
    rustc
    cargo
    rust-analyzer
    clippy
    rustfmt
  ];

  goToolchain = with pkgs; [
    go
    gopls
    delve
    gotools
  ];

  pythonToolchain = with pkgs; [
    python3
    python3Packages.pip
    python3Packages.ipython
    uv
    ruff
    poetry
  ];

  nodeToolchain = with pkgs; [
    nodejs_22
    pnpm
    typescript
    typescript-language-server
    biome
  ];

  jvmToolchain = with pkgs; [
    jdk
    maven
    gradle
  ];

  devLibraries = with pkgs; [
    stdenv.cc.cc
    glibc
    zlib
    zstd
    bzip2
    xz

    openssl
    curl
    libssh

    icu
    libxml2
    libxslt

    libGL
    libdrm
    libxkbcommon
    vulkan-loader

    libx11
    libxext
    libxrandr
    libxcursor
    libxi
    libxcomposite
    libxdamage
    libxfixes
    libxrender
    libxcb
    libxtst
    libxscrnsaver

    wayland
    dbus
    expat
    freetype
    fontconfig

    nss
    nspr
    at-spi2-atk
    at-spi2-core
    cups

    alsa-lib
    pipewire

    gtk3
    glib
    cairo
    pango
    gdk-pixbuf

    libsecret
    libnotify
    libgcrypt
  ];

  all =
    cToolchain
    ++ rustToolchain
    ++ goToolchain
    ++ pythonToolchain
    ++ nodeToolchain
    ++ jvmToolchain;
}
