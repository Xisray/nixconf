{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.opencode.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.hasScheme && cfg.targets.opencode.enable) {
      homefs.directories.".config/opencode".files = {
        "themes/nix.json" = cfg.colors {};
        "tui.json" = {
          value = {
            theme = "nix";
          };
          generator = builtins.toJSON;
        };
      };
    };
  };
}
