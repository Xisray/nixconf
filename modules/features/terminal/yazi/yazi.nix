{self, ...}: {
  flake.shellModules.yazi = {
    lib,
    pkgs,
    appearance,
    ...
  }: let
    yazi = self.wrappers.yazi or null;
    variant =
      if appearance.base24
      then "base24"
      else "base16";
    flavor = pkgs.linkFarm "yazi-flavor-${variant}" [
      {
        name = "flavor.toml";
        path = appearance.colors {
          template = ./${variant}.toml.mustache;
          extension = ".toml";
        };
      }
      {
        name = "tmtheme.xml";
        path = appearance.colors {
          template = ./${variant}.tmTheme.mustache;
          extension = ".xml";
        };
      }
    ];
  in {
    packages.yazi = lib.mkIf (yazi != null) (yazi.wrap {
      settings.theme = let
        block = {
          open =
            if (appearance.rounding == 0)
            then "█"
            else "";
          close =
            if (appearance.rounding == 0)
            then "█"
            else "";
        };
      in {
        status.sep_left = block;
        status.sep_right = block;
        indicator.padding = block;
        flavor = lib.mkIf (appearance.scheme != null) {
          dark = variant;
          light = variant;
        };
      };
      flavors.${variant} = lib.mkIf (appearance.scheme != null) flavor;
    });
  };
}
