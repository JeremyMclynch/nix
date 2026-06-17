#!/usr/bin/env bash
set -euo pipefail

# setup-container.sh - Run inside the container to install dev packages and X11

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root"
fi

info "Updating package lists..."
apt-get update

info "Installing development tools..."
apt-get install -y \
    build-essential \
    git \
    vim \
    neovim \
    tmux \
    htop \
    curl \
    wget \
    unzip \
    zip \
    man-db \
    manpages-dev

info "Installing compilers and build tools..."
apt-get install -y \
    gcc \
    g++ \
    clang \
    llvm \
    cmake \
    make \
    ninja-build \
    meson \
    pkg-config \
    autoconf \
    automake \
    libtool

info "Installing programming languages..."
apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    rustc \
    cargo \
    golang

info "Installing debugging tools..."
apt-get install -y \
    gdb \
    valgrind \
    strace \
    ltrace

info "Installing X11 environment..."
apt-get install -y \
    xorg \
    xauth \
    x11-xserver-utils \
    xterm \
    mesa-utils \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libxcursor-dev \
    libxi-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcomposite-dev \
    libxdamage-dev \
    libxfixes-dev \
    libxft-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libgtk-3-dev \
    libgtk-4-dev \
    qtbase5-dev

info "Installing fonts..."
apt-get install -y \
    fonts-dejavu \
    fonts-liberation \
    fonts-noto

info "Installing networking tools..."
apt-get install -y \
    openssh-client \
    iproute2 \
    iputils-ping \
    dnsutils

info "Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*

echo
echo -e "${GREEN}Setup complete!${NC}"
echo "You can now run X11 applications. Try: xterm or glxgears"
