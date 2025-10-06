{ config }:
{
  config.packages.universe.libidn = {
    stable = config.packages.universe.libidn.versions."2.3.8";
    latest = config.packages.universe.libidn.versions."2.3.8";

    versions = {
      "2.3.8" = ./versions/2.3.8.nix;
    };
  };
}

