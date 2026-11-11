#!/usr/bin/env bash
set -euo pipefail

pkexec systemd-nspawn \
  -u jeremy \
  --bind-ro=/dev/dri \
  --bind-ro=/tmp/.X11-unix \
  --bind=/dev/shm \
  --bind=/home/jeremy/:/home/jeremy/home \
  --setenv=DISPLAY=:0 \
  -D /var/lib/machines/dev \
  -- "${@}"
