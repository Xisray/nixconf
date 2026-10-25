{self, ...}: {
  flake.nixosModules.fastfetch = {
    config,
    lib,
    pkgs,
    ...
  }: let
    fastfetch = self.wrappers.fastfetch or null;
  in {
    shell.packages.fastfetch = lib.mkIf (config.appearance.rounding > 0 && fastfetch != null) (
      fastfetch.wrap {
        inherit pkgs;
        border = "rounded";
      }
    );
  };
}
