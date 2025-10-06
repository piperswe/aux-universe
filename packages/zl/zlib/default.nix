{ config }:
{
  config.packages.universe.zlib = {
    stable = config.packages.universe.zlib.versions."1.3.1";
    latest = config.packages.universe.zlib.versions."1.3.1";

    versions = {
      "1.3.1" = ./versions/1.3.1.nix;
    };
  };
}

