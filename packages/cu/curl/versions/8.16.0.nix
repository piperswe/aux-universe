{ config, global }:

let
  inherit (global)
    lib
    packages
    builders
    mirrors
    ;

  version = "8.16.0";

  platform = {
    build = lib.systems.withBuildInfo config.platform.build;
    host = lib.systems.withBuildInfo config.platform.host;
    target = lib.systems.withBuildInfo config.platform.target;
  };
in
{
  config = {
    meta = {
      description = "GNU Bourne-Again Shell, the de facto standard shell on Linux";
      homepage = "https://www.gnu.org/software/bash";
      license = lib.licenses.gpl3Plus;
      main = "/bin/vim";
    };

    platforms = [
      {
        build = "i686-linux";
      }
      {
        build = "x86_64-linux";
      }
      {
        build = "aarch64-linux";
      }
    ];

    builder = builders.foundation.basic;

    src = lib.fetchurl {
      url = "https://curl.se/download/curl-${version}.tar.xz";
      hash = "sha256-QMjN28tsxiUcA96kI6Ryps6kA3vmVLpc9d7G6y0i/x0=";
    };

    deps = {
      build = {
        build = {
          gnumake = packages.foundation.gnumake.versions."4.4.1-stage1-passthrough";
          gnupatch = packages.foundation.gnupatch.versions."2.7-stage1-passthrough";
          gnused = packages.foundation.gnused.versions."4.9-stage1-passthrough";
          gnutar = packages.foundation.gnutar.versions."1.35-stage1-passthrough";
          gnugrep = packages.foundation.gnugrep.versions."3.11-stage1-passthrough";
          gawk = packages.foundation.gawk.versions."5.2.2-stage1-passthrough";
          gzip = packages.foundation.gzip.versions."1.13-stage1-passthrough";
          diffutils = packages.foundation.diffutils.versions."3.10-stage1-passthrough";
          findutils = packages.foundation.findutils.versions."4.9.0-stage1-passthrough";
          gcc = packages.foundation.gcc.versions."13.2.0-stage4";
          binutils = packages.foundation.binutils.versions."2.41-stage1-passthrough";
	  xz = packages.foundation.xz.latest;
        };

        host = lib.attrs.when (config.platform.build != config.platform.host) {
          gcc = packages.foundation.gcc.versions."13.2.0-stage2";
          binutils = packages.foundation.binutils.versions."2.41-stage1";
        };
      };
      host = {
        host = {
	  openssl = packages.universe.openssl.stable;
	  libpsl = packages.universe.libpsl.stable;
	  zlib = packages.universe.zlib.stable;
	  nghttp2 = packages.universe.nghttp2.stable;
	  c-ares = packages.universe.c-ares.stable;
	  libidn = packages.universe.libidn.stable;
	};
      };
    };

    context = {
      "foundation:cflags" = [
        "-isystem ${config.package}/include"
        "-L${config.package}/lib"
        "-Wl,-rpath,${config.package}/lib"
      ];
    };

    phases = {
      unpack = ''
        tar xf ${config.src}
        cd curl-${version}
      '';

      configure =
        let
          flags = builtins.concatStringsSep " " (
            [
              "--prefix=$out"
              "--build=${platform.build.triple}"
              "--host=${platform.host.triple}"
	      "--with-openssl"
	      "--with-libpsl"
	      "--with-zlib"
	      "--with-nghttp2"
	      "--with-c-ares"
	      "--with-libidn"
            ]
          );
        in
        ''
          # Configure
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

