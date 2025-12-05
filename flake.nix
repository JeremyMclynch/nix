
{
  description = "Jeremy's NixOS config (desktop + laptop) with Home Manager, GNOME+GDM and optional Hyprland session";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Caelestia
    caelestiaCli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestiaShell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;

      mkHost =
        { name
        , system ? "x86_64-linux"
        , hostModule
        , username ? "jeremy"
        }:
        lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
            hostName = name;
          };

          modules = [
            hostModule

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # allow HM modules to access flake inputs (Caelestia, etc.)
              home-manager.extraSpecialArgs = {
                inherit inputs;
                hostName = name;
              };

              home-manager.users.${username} = import ./home/jeremy/default.nix;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop = mkHost {
          name = "desktop";
          hostModule = ./hosts/desktop/default.nix;
        };

        laptop = mkHost {
          name = "laptop";
          hostModule = ./hosts/laptop/default.nix;
        };
      };
    };
}
