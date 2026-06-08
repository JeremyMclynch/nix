{ pkgs, lib, ... }:

let
  toolchains = import ./toolchains.nix { inherit pkgs; };

  devShell =
    let base = pkgs.appimageTools.defaultFhsEnvArgs;
    in pkgs.buildFHSEnv (base // {
      name = "dev";
      targetPkgs = p:
        (base.targetPkgs p)
        ++ toolchains.all
        ++ toolchains.devLibraries
        ++ (with p; [
          git
          which
          file
          unzip
          zip
        ]);
      profile = ''
        export FHS=1
        export DEV_SHELL=1
      '';
      runScript = "bash";
      extraOutputsToInstall = [ "dev" ];
    });

  devshellWrapper = pkgs.writeShellScriptBin "devshell" ''
    set -e
    shell="''${SHELL:-${pkgs.bashInteractive}/bin/bash}"
    exec ${pkgs.nix}/bin/nix \
      --extra-experimental-features 'nix-command flakes' \
      develop /home/jeremy/nix --command "$shell" "$@"
  '';
in
{
  programs.nix-ld.libraries = toolchains.devLibraries;

  environment.systemPackages =
    toolchains.all
    ++ [ devShell devshellWrapper ];
}
