{ pkgs, ... }:

# Buildroot build environment (for e.g. embeddedTS buildroot-ts / TS-7250-V3).
#
# Buildroot will NOT build under the normal NixOS layout: it requires `file` at
# /usr/bin/file, and it downloads/builds host tools and (optionally) prebuilt
# toolchains that are hard-wired to FHS paths like /lib/ld-linux.so, which do
# not exist on NixOS. The supported, reliable approach is a buildFHSEnv: a
# lightweight chroot-like sandbox that presents a standard /usr + /lib so the
# Buildroot host tooling behaves exactly as it would on Debian/Ubuntu.
#
# Usage:
#   buildroot-fhs                         # drop into the FHS shell
#   git clone --recurse-submodules https://github.com/embeddedTS/buildroot-ts.git
#   cd buildroot-ts
#   make ts7250v3_defconfig
#   make                                  # builds in ./output/images
# Run it as your normal user (Buildroot refuses to run as root), on a path with
# no spaces. `make menuconfig` works too (ncurses is included).

let
  buildrootFHS = pkgs.buildFHSEnv {
    name = "buildroot-fhs";

    # Everything Buildroot's manual lists as mandatory/optional, plus the host
    # libraries and tools its package/toolchain/kernel builds commonly need.
    targetPkgs = p: with p; [
      # --- shell + Buildroot "mandatory packages" ---
      bashInteractive which gnused gnugrep gawk gnumake
      binutils diffutils findutils patch gcc perl
      gzip bzip2 gnutar cpio unzip rsync file bc
      coreutils util-linux gettext

      # --- source fetching (wget is mandatory; the rest cover packages that
      #     fetch via git/curl/svn/hg/scp) ---
      wget curl git cacert openssh subversion mercurial

      # --- host build helpers for toolchain, packages, and the kernel ---
      pkg-config cmake autoconf automake libtool m4
      flex bison gperf texinfo help2man
      python3 ncurses                       # python = legal-info/graphs; ncurses = menuconfig
      openssl elfutils zlib libxcrypt        # host libs: kernel objtool/certs, host tools
      xz lzop lz4 zstd                       # image/rootfs compressors
    ];

    # Make https fetches (wget/curl/git) trust the system CA bundle inside the
    # sandbox, and give a one-line hint on entry.
    profile = ''
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      export GIT_SSL_CAINFO="$SSL_CERT_FILE"
      export CURL_CA_BUNDLE="$SSL_CERT_FILE"
      echo "buildroot-fhs: FHS build shell ready. Build Buildroot here (not as root)."
    '';

    runScript = "bash";
  };
in
{
  environment.systemPackages = [ buildrootFHS ];
}
