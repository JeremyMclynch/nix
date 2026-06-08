{
  description = "Node.js devShell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_22
          pnpm
          typescript
          typescript-language-server
          biome
        ];

        shellHook = ''
          echo "Node.js devShell"
          echo "  node: $(node --version)"
          echo "  pnpm: $(pnpm --version)"
        '';
      };
    };
}
