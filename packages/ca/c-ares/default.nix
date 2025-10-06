{ config }:
{
  config.packages.universe.c-ares = {
    stable = config.packages.universe.c-ares.versions."1.34.5";
    latest = config.packages.universe.c-ares.versions."1.34.5";

    versions = {
      "1.34.5" = ./versions/1.34.5.nix;
    };
  };
}

