{
  description = "A very basic flake";

  inputs = {
    tidepool.url = "https://git.auxolotl.org/auxolotl/labs/archive/main.tar.gz?dir=tidepool";
  };

  outputs = { self, tidepool }: rec {
    auxModules.universe = ./packages;
    packages.x86_64-linux = builtins.mapAttrs (k: v: v.stable.package) (tidepool.extend {
      modules = [auxModules.universe];
    }).config.packages.universe;
  };
}
