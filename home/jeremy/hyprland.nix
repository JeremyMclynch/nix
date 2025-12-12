
{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      exec-once = [
        #"waybar"
        #"hyprpaper"
        # Uncomment to auto-start Caelestia in Hyprland:
         "caelestia shell -d"
      ];

      bind = [
       # "$mod, RETURN, exec, kitty"
       # "$mod, D, exec, wofi --show drun"
       # "$mod, Q, killactive"
       # "$mod, M, exit"
       # "$mod, F, fullscreen"
      ];
    };
  };
}
