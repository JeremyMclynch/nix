{
  description = "Jeremy's NixOS config (desktop + laptop) with Home Manager, GNOME+GDM and optional Hyprland session";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #caelestiaCli = {
    #  url = "github:caelestia-dots/cli";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #caelestiaShell = {
    #  url = "github:caelestia-dots/shell";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-matlab = {
    #   url = "gitlab:doronbehar/nix-matlab";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # anipy-cli bundles an old poetry2nix fork that does NOT build against
    # current nixos-unstable (e.g. python-modules/build no longer accepts
    # `tomli`, now stdlib; lib.licenses gained AND/OR/WITH operators that its
    # license lookup chokes on). Pin it to the exact nixpkgs anipy-cli itself
    # locks (Dec 2025), which predates both breakages, rather than following our
    # bleeding-edge nixpkgs. Removing the follows entirely is not enough: nix
    # re-resolves the transitive input to a too-new revision.
    nixpkgs-anipy.url = "github:NixOS/nixpkgs/addf7cf5f383a3101ecfba091b98d0a1263dc9b8";

    anipy-cli = {
      url = "github:sdaqo/anipy-cli";
      inputs.nixpkgs.follows = "nixpkgs-anipy";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      toolchains = import ./modules/dev/toolchains.nix { inherit pkgs; };

      # flake-overlays = [
      #   nix-matlab.overlay
      # ];

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

        nixos-rog = mkHost {
          name = "nixos-rog";
          hostModule = ./hosts/nixos-rog/default.nix;
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = toolchains.all;

        shellHook = ''
          export IN_DEVSHELL=1
          echo "devshell ready (gcc $(${pkgs.gcc}/bin/gcc -dumpversion), $(${pkgs.rustc}/bin/rustc --version | cut -d' ' -f2), go $(${pkgs.go}/bin/go version | awk '{print $3}'), python $(${pkgs.python3}/bin/python3 -V | cut -d' ' -f2), node $(${pkgs.nodejs_22}/bin/node --version), jdk $(${pkgs.jdk}/bin/java --version | head -1 | awk '{print $2}'))"
        '';
      };

      templates = {
        cpp = {
          path = ./templates/cpp;
          description = "C/C++ devShell (gcc, clang, cmake, gdb)";
        };
        rust = {
          path = ./templates/rust;
          description = "Rust devShell (rustc, cargo, rust-analyzer)";
        };
        go = {
          path = ./templates/go;
          description = "Go devShell (go, gopls, delve)";
        };
        python = {
          path = ./templates/python;
          description = "Python devShell (python3, uv, ruff)";
        };
        node = {
          path = ./templates/node;
          description = "Node.js devShell (nodejs, pnpm, typescript)";
        };
      };
    };
}
