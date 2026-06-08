{
  description = "C/C++ devShell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          gcc
          clang
          clang-tools
          cmake
          gnumake
          ninja
          meson
          pkg-config
          gdb
          lldb
          valgrind
          bear
        ];

        shellHook = ''
          echo "C/C++ devShell"
          echo "  gcc:   $(gcc --version | head -1)"
          echo "  clang: $(clang --version | head -1)"
        '';
      };
    };
}
