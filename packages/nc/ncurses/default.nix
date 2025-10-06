{ config }:
{
  config.packages.universe.ncurses = {
    stable = config.packages.universe.ncurses.versions."6.5";
    latest = config.packages.universe.ncurses.versions."6.5";

    versions = {
      "6.5" = ./versions/6.5.nix;
    };
  };
}

