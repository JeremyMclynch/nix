
{ pkgs, ... }:
{
  # Runtime helpers Caelestia commonly uses (system-wide)
  environment.systemPackages = with pkgs; [
    ddcutil
    brightnessctl
    app2unit
    cava
    lm_sensors
    fish
    aubio
    swappy
    libqalculate
  ];

  # Fonts used by many Caelestia configs (system-wide)
  fonts.packages = with pkgs; [ nerd-fonts.caskaydia-cove ];
}
