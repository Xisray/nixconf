{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.console.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.targets.console.enable) {
      console.colors = lib.mkIf cfg.hasScheme (with cfg.colors; [base00 base08 base0B base0A base0D base0E base0C base05 base03 base12 base14 base13 base16 base17 base15 base07]);
    };
  };
}
