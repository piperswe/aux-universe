{ config }:
{
  config.packages.universe.libpsl = {
    stable = config.packages.universe.libpsl.versions."0.21.5";
    latest = config.packages.universe.libpsl.versions."0.21.5";

    versions = {
      "0.21.5" = ./versions/0.21.5.nix;
    };
  };
}

