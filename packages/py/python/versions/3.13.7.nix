{ config, global }:

let
  inherit (global)
    lib
    packages
    builders
    ;

  version = config.version;

  platform = {
    build = lib.systems.withBuildInfo config.platform.build;
    host = lib.systems.withBuildInfo config.platform.host;
    target = lib.systems.withBuildInfo config.platform.target;
  };
in
{
  config = {
    meta = {
      description = "A high-level dynamically-typed programming language.";
      homepage = "https://www.python.org";
      license = lib.licenses.psfl;
    };

    platforms = [
      {
        build = "i686-linux";
      }
      {
        build = "i686-linux";
        host = "x86_64-linux";
      }
      {
        build = "x86_64-linux";
        host = "@linux";
      }
    ];

    builder = builders.foundation.basic;

    src = lib.fetchurl {
      url = "https://www.python.org/ftp/python/${version}/Python-${version}.tar.xz";
      hash = "sha256-VGL5CZ39MOI43vg8cdkYl9jKpf9uvHpQ8U1IAs2qp5o=";
    };

    deps = {
      build = {
        build =
          (
            if (config.platform.build == "i686-linux") then
              {
                gnumake = packages.foundation.gnumake.versions."4.4.1-bootstrap";
                gnupatch = packages.foundation.gnupatch.versions."2.7-bootstrap";
                gnused = packages.foundation.gnused.versions."4.9-bootstrap";
                gnutar = packages.foundation.gnutar.versions."1.35-bootstrap";
                gnugrep = packages.foundation.gnugrep.versions."3.11-bootstrap";
                gawk = packages.foundation.gawk.versions."5.2.2-bootstrap";
                diffutils = packages.foundation.diffutils.versions."3.10-bootstrap";
                findutils = packages.foundation.findutils.versions."4.9.0-bootstrap";
                xz = packages.foundation.xz.versions."5.4.3-bootstrap";
                gcc = packages.foundation.gcc.versions."13.2.0-bootstrap";
                binutils = packages.foundation.binutils.versions."2.41-bootstrap";
              }
            else
              {
                gnumake = packages.foundation.gnumake.versions."4.4.1-stage1-passthrough";
                gnupatch = packages.foundation.gnupatch.versions."2.7-stage1-passthrough";
                gnused = packages.foundation.gnused.versions."4.9-stage1-passthrough";
                gnutar = packages.foundation.gnutar.versions."1.35-stage1-passthrough";
                gnugrep = packages.foundation.gnugrep.versions."3.11-stage1-passthrough";
                gawk = packages.foundation.gawk.versions."5.2.2-stage1-passthrough";
                diffutils = packages.foundation.diffutils.versions."3.10-stage1-passthrough";
                findutils = packages.foundation.findutils.versions."4.9.0-stage1-passthrough";
                xz = packages.foundation.xz.versions."5.4.3-stage1-passthrough";
                gcc = packages.foundation.gcc.versions."13.2.0-stage4";
                binutils = packages.foundation.binutils.versions."2.41-stage1-passthrough";
              }
          )
          // lib.attrs.when (config.platform.build != config.platform.host) {
            python = packages.universe.python.stable;
          };

        host = lib.attrs.when (config.platform.build != config.platform.host) {
          gcc = packages.foundation.gcc.versions."13.2.0-stage2";
          binutils = packages.foundation.binutils.versions."2.41-stage1";
        };
      };

      host = {
        host = {
          zlib =
            if (config.platform.build == "i686-linux" && config.platform.build == config.platform.host) then
              packages.foundation.zlib.versions."1.3-bootstrap"
            else
              packages.foundation.zlib.versions."1.3-stage1";
        };
      };
    };

    phases = {
      unpack = ''
        # Unpack
        tar xf ${config.src}
        cd Python-${version}
      '';

      configure =

        let
          flags = builtins.concatStringsSep " " (
            [
              "--prefix=$out"
              "--build=${platform.build.triple}"
              "--host=${platform.host.triple}"
            ]
            ++ lib.lists.when (config.platform.build != config.platform.host) [
              "--with-build-python=\"${config.deps.build.build.python.package}/bin/python3\""
              "ac_cv_buggy_getaddrinfo=no"
              "ac_cv_file__dev_ptmx=yes"
              "ac_cv_file__dev_ptc=yes"
            ]
          );
        in
        ''
          bash ./configure ${flags}            
        '';

      build = ''
        # Build
        make -j $NIX_BUILD_CORES
      '';

      install = ''
        # Install
        make -j $NIX_BUILD_CORES install
      '';
    };
  };
}

