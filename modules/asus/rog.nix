{ config, pkgs, lib, ... }:
{
  # ASUS ROG daemon — fan curves, performance profiles, keyboard RGB, charging limit
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # GPU switcher daemon (integrated / hybrid / dedicated / vfio)
  services.supergfxd.enable = true;

  # NVIDIA drivers (required for supergfxd dedicated/hybrid modes)
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # PRIME offload — dGPU only active when explicitly requested
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Update these BusIDs after running: lspci | grep -E "VGA|3D"
    amdgpuBusId = "PCI:7:0:0";
    nvidiaBusId  = "PCI:1:0:0";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.rocm-runtime
    ];
  };

  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
    nvtopPackages.full
    lm_sensors
    zenmonitor
  ];
}
