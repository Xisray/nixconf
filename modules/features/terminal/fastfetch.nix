{self, ...}: {
  flake.shellModules.fastfetch = {
    lib,
    appearance,
    pkgs,
    ...
  }: let
    fastfetch = self.wrappers.fastfetch or null;
  in {
    packages.fastfetch = lib.mkIf (appearance.rounding > 0 && fastfetch != null) (fastfetch.wrap {
      inherit pkgs;
      border = "rounded";
    });
  };
}
