#!/usr/bin/env bash
pkexec systemd-nspawn \
  -u jeremy \
  --bind-ro=/dev/dri \
  --bind-ro=/tmp/.X11-unix \
  --bind=/dev/shm \
  --bind=/home/jeremy/MATLAB:/usr/local/MATLAB \
  --bind=/home/jeremy/Documents/MATLAB:/home/jeremy/Documents/MATLAB \
  --setenv=DISPLAY=:0 \
  -D /var/lib/machines/matlab \
  -- /bin/bash -lc '/usr/local/MATLAB/R2025b/bin/matlab -desktop'
