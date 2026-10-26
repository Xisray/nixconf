{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.ayugram = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      settingsPath = lib.mkOption {
        type = lib.types.str;
        default = ".local/share/AyuGramDesktop/tdata/ayu_settings.json";
      };
    };
    config = lib.mkIf (cfg.targets.ayugram.enable) {
      fpatcher.ayugram = {
        path = cfg.targets.ayugram.settingsPath;
        content = {
          avatarCorners =
            if cfg.rounding == 0
            then 0
            else 23; # 23 max - circle, 0 - square
          singleCornerRadius = true;
          messageBubbleRadius =
            if cfg.rounding == 0
            then 0
            else 16; # 16 max
          removeMessageTail = cfg.rounding == 0;
        };
        format = "json";
      };
    };
  };
}
