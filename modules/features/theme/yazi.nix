{
  flake.nixosModules.theme = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.preferences.theme;
    yaziSettings = let
      block = {
        open = "█";
        close = "█";
      };
    in
      {
        flavor.dark = cfg.provider;
        flavor.light = cfg.provider;
      }
      // lib.optionalAttrs (cfg.corner.radius == 0) {
        status.sep_left = block;
        status.sep_right = block;
        indicator.padding = block;
      };
  in {
    preferences.theme.targets.yazi = {
      enable = lib.mkDefault (cfg.autoEnable && config.programs.yazi.enable);
    };
    home.xdg.config.files = lib.mkIf (cfg.targets.yazi.enable && !config.programs.yazi.enable) {
      "yazi/theme.toml" = {
        generator = lib.mkDefault ((pkgs.formats.toml {}).generate "theme.toml");
        value = yaziSettings;
      };
    };
    programs.yazi.settings.theme = lib.mkIf (cfg.targets.yazi.enable && config.programs.yazi.enable) yaziSettings;
  };
}
