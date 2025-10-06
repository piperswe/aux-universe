{ config }:
{
  config.packages.universe.vim = {
    stable = config.packages.universe.vim.versions."9.0";
    latest = config.packages.universe.vim.versions."9.0";

    versions = {
      "9.0" = ./versions/9.0.nix;
    };
  };
}

