{ config }:
{
  config.packages.universe.nghttp2 = {
    stable = config.packages.universe.nghttp2.versions."1.67.1";
    latest = config.packages.universe.nghttp2.versions."1.67.1";

    versions = {
      "1.67.1" = ./versions/1.67.1.nix;
    };
  };
}

