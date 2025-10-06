{ config }:
{
  config.packages.universe.vim = {
    stable = config.packages.universe.vim.versions."9.0";
    latest = config.packages.universe.vim.versions."9.1.1833";

    versions = {
      "9.1.1833" = ./versions/9.1.1833.nix;
      "9.0" = ./versions/9.0.nix;
      "8.2" = ./versions/8.2.nix;
    };
  };
}

