#!/usr/bin/env bash
set -euo pipefail

# create-container.sh - Create an Ubuntu systemd-nspawn container using mkosi
# Usage: ./create-container.sh [container-name]

CONTAINER_NAME="${1:-dev-container}"
CONTAINER_DIR="${HOME}/.local/share/mkosi-containers/${CONTAINER_NAME}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

check_dependencies() {
    info "Checking dependencies..."
    local missing=()

    for cmd in mkosi systemd-nspawn; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing dependencies: ${missing[*]}\nInstall with: nix-shell -p mkosi"
    fi
}

create_mkosi_config() {
    info "Creating mkosi configuration..."
    mkdir -p "${CONTAINER_DIR}"

    cat > "${CONTAINER_DIR}/mkosi.conf" << 'EOF'
[Distribution]
Distribution=ubuntu
Release=noble

[Output]
Format=directory
Output=image

[Content]
Bootable=no
WithDocs=yes

Packages=
    systemd
    dbus
    sudo
    passwd
    curl
    ca-certificates
EOF

    info "Configuration written to ${CONTAINER_DIR}/mkosi.conf"
}

build_container() {
    info "Building container image (this may take a while)..."
    cd "${CONTAINER_DIR}"
    sudo mkosi --force
    info "Container image built successfully"
}

copy_setup_script() {
    info "Copying setup script into container..."
    sudo cp "${SCRIPT_DIR}/setup-container.sh" "${CONTAINER_DIR}/image/root/setup.sh"
    sudo chmod +x "${CONTAINER_DIR}/image/root/setup.sh"
}

create_launch_script() {
    local launch_script="${CONTAINER_DIR}/launch.sh"

    cat > "${launch_script}" << EOF
#!/usr/bin/env bash
set -euo pipefail

CONTAINER_DIR="${CONTAINER_DIR}"
CONTAINER_NAME="${CONTAINER_NAME}"

xhost +local: 2>/dev/null || true

exec sudo systemd-nspawn \\
    --directory="\${CONTAINER_DIR}/image" \\
    --machine="\${CONTAINER_NAME}" \\
    --boot \\
    --bind=/tmp/.X11-unix:/tmp/.X11-unix \\
    --bind-ro=/etc/resolv.conf:/etc/resolv.conf \\
    --setenv=DISPLAY="\${DISPLAY:-:0}" \\
    --setenv=TERM="\${TERM:-xterm-256color}" \\
    --capability=all \\
    --property=DeviceAllow='char-drm rw' \\
    --bind=/dev/dri:/dev/dri \\
    "\$@"
EOF

    chmod +x "${launch_script}"
    info "Launch script created at ${launch_script}"
}

create_shell_script() {
    local shell_script="${CONTAINER_DIR}/shell.sh"

    cat > "${shell_script}" << EOF
#!/usr/bin/env bash
set -euo pipefail

CONTAINER_DIR="${CONTAINER_DIR}"
CONTAINER_NAME="${CONTAINER_NAME}"

xhost +local: 2>/dev/null || true

exec sudo systemd-nspawn \\
    --directory="\${CONTAINER_DIR}/image" \\
    --machine="\${CONTAINER_NAME}" \\
    --bind=/tmp/.X11-unix:/tmp/.X11-unix \\
    --bind-ro=/etc/resolv.conf:/etc/resolv.conf \\
    --setenv=DISPLAY="\${DISPLAY:-:0}" \\
    --setenv=TERM="\${TERM:-xterm-256color}" \\
    --capability=all \\
    --property=DeviceAllow='char-drm rw' \\
    --bind=/dev/dri:/dev/dri \\
    "\$@"
EOF

    chmod +x "${shell_script}"
    info "Shell script created at ${shell_script}"
}

print_usage() {
    cat << EOF

${GREEN}Container created successfully!${NC}

${YELLOW}Next steps:${NC}

  1. Start a shell in the container:
     ${CONTAINER_DIR}/shell.sh

  2. Run the setup script inside the container:
     /root/setup.sh

  3. After setup, you can boot with systemd:
     ${CONTAINER_DIR}/launch.sh

EOF
}

main() {
    echo -e "${GREEN}=== Ubuntu Container Setup ===${NC}"
    echo "Container: ${CONTAINER_NAME}"
    echo "Location: ${CONTAINER_DIR}"
    echo

    check_dependencies
    create_mkosi_config
    build_container
    copy_setup_script
    create_launch_script
    create_shell_script
    print_usage
}

main
