{
  description = "A very basic flake";

  inputs = {
    tidepool.url = "https://git.auxolotl.org/auxolotl/labs/archive/main.tar.gz?dir=tidepool";
  };

  outputs = { self, tidepool }: rec {
    auxModules.universe = ./packages;
    auxUniverse = tidepool.extend { modules = [auxModules.universe]; };
    packages.x86_64-linux = builtins.mapAttrs (k: v: v.stable.package) auxUniverse.config.packages.universe;
    versionedPackages.x86_64-linux = builtins.mapAttrs (k: v: builtins.mapAttrs (k: v: v.packages) v.versions) auxUniverse.config.packages.universe;
  };
}
