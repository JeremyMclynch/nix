{
  description = "Python devShell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python3
          python3Packages.pip
          python3Packages.ipython
          uv
          ruff
          poetry
        ];

        shellHook = ''
          echo "Python devShell"
          echo "  $(python3 --version)"
          echo "  uv:    $(uv --version)"
        '';
      };
    };
}
