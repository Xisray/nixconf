{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.btop.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.targets.btop.enable) {
      homefs.directories.".config/btop".files = lib.mkMerge [
        (lib.mkIf (cfg.hasScheme) {
          "themes/nix.theme" = cfg.colors {src = ./btop.theme.mustache;};
        })
        {
          "btop.conf".text = ''
            ${lib.optionalString (cfg.hasScheme) "color_theme = \"nix\""}
            rounded_corners = "${
              if cfg.rounding > 0
              then "True"
              else "False"
            }"
          '';
        }
      ];
    };
  };
}
