{ config }:
{
  config.packages.universe.perl = {
    stable = config.packages.universe.perl.versions."5.42.0";
    latest = config.packages.universe.perl.versions."5.42.0";

    versions = {
      "5.42.0" = ./versions/5.42.0.nix;
    };
  };
}

