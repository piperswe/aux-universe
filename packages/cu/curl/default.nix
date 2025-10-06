{ config }:
{
  config.packages.universe.curl = {
    stable = config.packages.universe.curl.versions."8.16.0";
    latest = config.packages.universe.curl.versions."8.16.0";

    versions = {
      "8.16.0" = ./versions/8.16.0.nix;
    };
  };
}

