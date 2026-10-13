{self, ...}: {
  flake.shellModules.yazi = {
    lib,
    pkgs,
    appearance,
    ...
  }: let
    yazi = self.wrappers.yazi or null;
    flavor = pkgs.linkFarm "yazi-flavor-nix" [
      {
        name = "flavor.toml";
        path = appearance.colors {
          src = ./yazi.toml.mustache;
        };
      }
      {
        name = "tmtheme.xml";
        path = appearance.colors {
          src = ../bat/bat.tmTheme.mustache;
          ext = ".xml";
        };
      }
    ];
  in {
    packages.yazi = lib.mkIf (yazi != null) (yazi.wrap {
      inherit pkgs;
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
          dark = "nix";
          light = "nix";
        };
      };
      flavors.nix = lib.mkIf (appearance.scheme != null) flavor;
    });
  };
}
