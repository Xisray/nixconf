{
  flake.nixosModules.theme = {
    config,
    lib,
    wlib,
    ...
  }: let
    cfg = config.preferences.theme;
  in {
    preferences.theme.targets.niri = {
      enable = lib.mkDefault (cfg.autoEnable && config.programs.niri.enable);
    };

    home.xdg.config.files = lib.mkIf cfg.targets.niri.enable {
      "niri/config.kdl" = {
        generator = lib.mkDefault (value:
          wlib.toKdl (_: {
            version = 1;
            content = value;
          }));
        value = lib.mkMerge [
          (lib.mkBefore [
            {
              include = _: {
                props = {
                  optional = true;
                  "\"./${cfg.provider}.kdl\"" = _: {};
                };
              };
            }
          ])
          [
            {
              blur =
                if cfg.blur.enable
                then {
                  passes = 2;
                  offset = 3.0;
                  noise = 0.03;
                  saturation = 1.0;
                }
                else {off = _: {};};
            }
            {rounded_corners = cfg.corner.radius > 0;}
          ]
          (lib.optionals (cfg.corner.radius > 0) [
            {
              window-rule = {
                geometry-corner-radius = cfg.corner.radius;
                clip-to-geometry = true;
              };
            }
          ])
        ];
      };
    };
  };
}
