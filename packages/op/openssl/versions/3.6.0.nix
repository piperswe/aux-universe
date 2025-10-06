{ config, global }:

let
  inherit (global)
    lib
    packages
    builders
    mirrors
    ;

  version = "3.6.0";

  patches = [
    ../patches/3.5-use-etc-ssl-certs.patch
  ];

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
      url = "https://github.com/openssl/openssl/releases/download/openssl-3.6.0/openssl-3.6.0.tar.gz";
      hash = "sha256-tqX0S362nj+jXb8VUkQFtEg3pIHUPYHa3d4/8h/LuOk=";
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
	  
	  perl = packages.universe.perl.stable;
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
        cd openssl-${version}
      '';

      patch = ''
        ${lib.strings.concatMapSep "\n" (file: "patch -Np1 -i ${file}") patches}
      '';

      configure =
        let
          flags = builtins.concatStringsSep " " (
            [
              "--prefix=$out"
	      "--libdir=lib"
	      "--openssldir=etc/ssl"
            ]
          );
        in
        ''
          # Configure
	  export CFLAGS="-Wl,-rpath,$out/lib"
	  export LDFLAGS="-Wl,-rpath,$out/lib"
          perl ./Configure ${flags}
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

