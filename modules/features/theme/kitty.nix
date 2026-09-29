{
  flake.nixosModules.theme = {
    config,
    lib,
    ...
  }: let
    cfg = config.preferences.theme;
  in {
    preferences.theme.targets.kitty = {
      enable = lib.mkDefault false;
    };
    home.xdg.config.files = lib.mkIf cfg.targets.kitty.enable {
      "kitty/kitty.conf" = {
        generator = lib.mkDefault lib.concatLines;
        value = [
          "include themes/${cfg.provider}.conf"
          "background_opacity ${toString cfg.opacity}"
        ];
      };
    };
  };
}
