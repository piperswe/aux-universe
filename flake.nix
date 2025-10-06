{
  description = "A very basic flake";

  inputs = {
    tidepool.url = "git+https://git.auxolotl.org/pmc/labs.git?ref=update-foundation-10-6-25&dir=tidepool";
  };

  outputs = { self, tidepool }: 
    let
      module = ./packages;
      universe = tidepool.extend { modules = [module]; };
      systems = ["i686-linux" "x86_64-linux" "aarch64-linux"];
      eachSystem = f: tidepool.lib.attrs.generate systems f;
    in
    rec {
      auxModules.universe = ./packages;
      auxUniverse = tidepool.extend { modules = [auxModules.universe]; };
      packages = eachSystem (system: builtins.mapAttrs (k: v: v.stable.packages."${system}"."${system}"."${system}".package) auxUniverse.config.packages.universe);
      packagesLatest = eachSystem (system: builtins.mapAttrs (k: v: v.latest.packages."${system}"."${system}"."${system}".package) auxUniverse.config.packages.universe);
      versionedPackages = eachSystem (system: builtins.mapAttrs (k: v: builtins.mapAttrs (k: v: v.packages."${system}"."${system}"."${system}".package) v.versions) auxUniverse.config.packages.universe);
    };
}
