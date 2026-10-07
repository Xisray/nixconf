{self, ...}: {
  flake.shellModules.fastfetch = {
    lib,
    appearance,
    ...
  }: let
    fastfetch = self.wrappers.fastfetch or null;
  in {
    packages.fastfetch = lib.mkIf (appearance.rounding > 0 && fastfetch != null) (fastfetch.wrap {
      border = "rounded";
    });
  };
}
