{ pkgs, inputs, ... }:
let
  system = pkgs.system;
in
{
  home.packages =
    [
      inputs.caelestiaCli.packages.${system}.with-shell
    ]
    ++ (with pkgs; [
      libnotify
      grim
      slurp
      wl-clipboard
      cliphist
      fuzzel
      dart-sass
     # glib2
      app2unit
      swappy
      gpu-screen-recorder
    ]);
}

