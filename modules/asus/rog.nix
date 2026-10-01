{ config, pkgs, lib, ... }:
{
  # ASUS ROG daemon — fan curves, performance profiles, keyboard RGB, charging limit
  services.asusd = {
    enable = true;
    #enableUserService = true;
  };

  # supergfxd disabled — it resets dgpu_disable on startup, fighting the firmware setting
  services.supergfxd.enable = false;

  # Disable dGPU at the ASUS firmware level (same as writing 1 to the sysfs attr manually).
  # Runs after asusd so asusd's own WMI init doesn't overwrite it.
  systemd.services.asus-dgpu-disable = {
    description = "Disable ASUS dGPU via firmware attribute";
    wantedBy = [ "multi-user.target" ];
    after = [ "asusd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 1 > /sys/class/firmware-attributes/asus-armoury/attributes/dgpu_disable/current_value'";
    };
  };

  # Prevent NVIDIA kernel modules from loading at all
  boot.blacklistedKernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" "nouveau" ];

  # AMD iGPU only
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.rocm-runtime
    ];
  };

  environment.systemPackages = with pkgs; [
    asusctl
    nvtopPackages.full
    lm_sensors
    zenmonitor
  ];
}
