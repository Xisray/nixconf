{
  flake.nixosModules.appearance = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.yazi.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    config = lib.mkIf (cfg.targets.yazi.enable) {
      homefs.directories.".config/yazi" = {
        directories."flavors/nix.yazi".files = lib.mkIf (cfg.hasScheme) {
          "flavor.toml" = cfg.colors {src = ./yazi.toml.mustache;};
          "tmtheme.xml" = cfg.colors {src = ../bat/bat.tmTheme.mustache;};
        };
        files."theme.toml" = (pkgs.formats.toml {}).generate "yazi-theme.toml" (let
          block = {
            open =
              if (cfg.rounding == 0)
              then "█"
              else "";
            close =
              if (cfg.rounding == 0)
              then "█"
              else "";
          };
        in
          {
            status.sep_left = block;
            status.sep_right = block;
            indicator.padding = block;
          }
          // lib.optionalAttrs cfg.hasScheme {
            flavor = {
              dark = "nix";
              light = "nix";
            };
          });
      };
    };
  };
}
