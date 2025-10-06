{ version, url, hash, dir ? null }:
{ config, global }:

let
  inherit (global)
    lib
    packages
    builders
    mirrors
    ;
  
  d = if dir == null then "vim${builtins.replaceStrings ["."] [""] version}" else dir;

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
      inherit url hash;
    };

    deps = {
      build = {
        build = {
	  bzip2 = packages.foundation.bzip2.versions."1.0.8-stage1-passthrough";
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
        };

        host = lib.attrs.when (config.platform.build != config.platform.host) {
          gcc = packages.foundation.gcc.versions."13.2.0-stage2";
          binutils = packages.foundation.binutils.versions."2.41-stage1";
        };
      };
      host = {
        host = {
	  ncurses = packages.universe.ncurses.stable;
	};
      };
    };

    phases = {
      unpack = ''
        tar xf ${config.src}
        cd ${d}
      '';

      configure =
        let
          flags = builtins.concatStringsSep " " (
            [
              "--prefix=$out"
              "--build=${platform.build.triple}"
              "--host=${platform.host.triple}"
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

