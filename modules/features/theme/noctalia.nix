{
  flake.nixosModules.theme = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.preferences.theme;
  in {
    preferences.theme.targets.noctalia = {
      enable = lib.mkDefault (cfg.autoEnable && config.programs.noctalia.enable);
    };
    home.xdg.config.files = lib.mkIf cfg.targets.noctalia.enable {
      "noctalia/settings.toml" = {
        generator = lib.mkDefault ((pkgs.formats.toml {}).generate "settings.toml");
        value = {
          osd.background_opacity = cfg.opacity;
          notification.background_opacity = cfg.opacity;
          shell.corner_radius_scale = lib.max 0.0 (lib.min 2.0 (cfg.corner.radius / 12.0));
          shell.panel.transparency_mode =
            if cfg.opacity < 1.0
            then "soft"
            else "solid";
          bar.default = {
            background_opacity = cfg.opacity;
            capsule_radius = cfg.corner.radius;
          };
        };
      };
    };
  };
}
