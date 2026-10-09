{ config, pkgs, lib, ... }:
{
  # NVIDIA drivers for the desktop's RTX 5080 (Blackwell).
  #
  # Blackwell (RTX 50-series) is supported ONLY by NVIDIA's open kernel modules,
  # so `open = true` is mandatory here -- the proprietary/closed modules will not
  # drive this GPU. It also needs a recent driver branch (>= 570); the `stable`
  # nvidia package on current nixos-unstable is new enough.
  #
  # The AMD GPU is deliberately kept working too: amdgpu is an in-kernel driver
  # that loads automatically for any AMD card present, and it is also listed in
  # videoDrivers below, so the machine still boots on the old card if the 5080 is
  # pulled -- "just in case for now".

  # Xorg may use either GPU. Wayland sessions (GDM/GNOME, Hyprland) load the
  # kernel driver directly and ignore this list; it only governs Xorg
  # (the xfce/xrdp session on this host). nvidia is listed first as the intended
  # primary, with amdgpu kept as a fallback.
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

  hardware.nvidia = {
    modesetting.enable = true;   # required for Wayland and for a clean console/X handoff
    open = true;                 # REQUIRED for Blackwell / RTX 50-series
    nvidiaSettings = true;       # install the nvidia-settings control panel
    # `latest` = the newest driver branch nixpkgs packages (newer than `stable`
    # or `beta`). Update it along with nixpkgs via `nix flake update nixpkgs`.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    # powerManagement is left at its default (off): this host disables
    # sleep/suspend/hibernate entirely, so the suspend/resume workarounds that
    # flag enables are not needed.
  };

  # Load the NVIDIA modules in the initrd (early KMS). Recommended for NVIDIA on
  # Wayland: modesetting is active from boot, which avoids mode/HDR-switch glitches
  # and flicker. Merges with hardware-configuration.nix's (empty) initrd list.
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  # Hardware video decode/encode.
  #
  # NVENC (encode) and NVDEC (decode) ship inside the nvidia driver itself, so
  # apps that call them directly already work once the driver is loaded:
  #   - ffmpeg:  h264_nvenc / hevc_nvenc / av1_nvenc, and *_cuvid decoders
  #   - mpv:     hwdec=nvdec  (or nvdec-copy)
  #   - OBS:     NVENC encoders
  #   - VDPAU:   provided natively by the driver (check with `vdpauinfo`)
  #
  # The piece that is NOT built in is VA-API: browsers (Firefox/Chromium) and
  # most GTK apps speak VA-API, so `nvidia-vaapi-driver` bridges VA-API onto
  # NVDEC. It is a decode bridge (VA-API encode is not supported on NVIDIA; use
  # NVENC directly for encoding).
  hardware.graphics.extraPackages = with pkgs; [
    nvidia-vaapi-driver
  ];

  # Route VA-API to the nvidia backend. libva cannot auto-detect the nvidia
  # driver the way it does radeonsi for amdgpu, so this must be set explicitly;
  # NVD_BACKEND=direct is the recommended path on modesetting (nvidia-drm) setups.
  #
  # Caveat for the AMD fallback: these force VA-API onto nvidia. If you ever boot
  # on the AMD card, unset LIBVA_DRIVER_NAME (or set it to "radeonsi") so VA-API
  # uses the AMD driver again.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    # Make GLX apps (XWayland / Xorg clients) pick the NVIDIA vendor library.
    # Recommended by the Hyprland NVIDIA guide. GBM_BACKEND is deliberately NOT
    # set -- it is no longer needed with modern drivers and is a known cause of
    # Chromium/Electron glitches, of which this host has many.
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # GPU monitoring plus VA-API/VDPAU diagnostics (`vainfo`, `vdpauinfo`).
  # nvtop's `full` build covers both NVIDIA and AMD while both cards may be in
  # the machine.
  environment.systemPackages = with pkgs; [
    nvtopPackages.full
    libva-utils
    vdpauinfo
  ];
}
