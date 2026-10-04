
{ pkgs, lib, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot = {

    plymouth = {
      enable = true;
      theme = lib.mkDefault "rings";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "rings" ];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Boot menu timeout (seconds).
    # Normally 0 = hidden (boots the default generation immediately; the menu can
    # still be opened by pressing a key). Temporarily set to 5 so the systemd-boot
    # generation list is shown on every boot -- lets you pick an older, known-good
    # generation if the new config misbehaves (e.g. during the GPU/driver swap).
    # Set back to 0 to restore the silent/instant boot.
    loader.timeout = 5;

  };

}
