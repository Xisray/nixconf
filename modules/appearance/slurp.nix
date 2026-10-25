{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.slurp.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.hasScheme && cfg.targets.slurp.enable) {
      homefs.files.".config/slurp/config.json" = lib.mkIf (config.appearance.hasScheme) {
        value = with config.appearance.colors.withHashtag; {
          borderColor = primary;
          selectionColor = "${primary}11";
        };
        generator = builtins.toJSON;
      };
    };
  };
}
