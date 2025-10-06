{ config }:
{
  config.packages.universe.python = {
    stable = config.packages.universe.python.versions."3.13.7";
    latest = config.packages.universe.python.versions."3.13.7";

    versions = {
      "3.13.7" = ./versions/3.13.7.nix;
    };
  };
}

