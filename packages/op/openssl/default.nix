{ config }:
{
  config.packages.universe.openssl = {
    stable = config.packages.universe.openssl.versions."3.6.0";
    latest = config.packages.universe.openssl.versions."3.6.0";

    versions = {
      "3.6.0" = ./versions/3.6.0.nix;
    };
  };
}

