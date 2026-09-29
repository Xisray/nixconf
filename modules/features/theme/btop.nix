{
  flake.nixosModules.theme = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.preferences.theme;
    btopGenerator =
      (pkgs.formats.keyValue {
        mkKeyValue = lib.generators.mkKeyValueDefault {
          mkValueString = v:
            if lib.isBool v
            then
              (
                if v
                then "True"
                else "False"
              )
            else if lib.isString v
            then ''"${v}"''
            else lib.generators.mkValueStringDefault {} v;
        } " = ";
      }).generate;
  in {
    preferences.theme.targets.btop = {
      enable = lib.mkDefault false;
    };
    home.xdg.config.files = lib.mkIf cfg.targets.btop.enable {
      "btop/btop.conf" = {
        generator = lib.mkDefault btopGenerator;
        value = {
          color_theme = cfg.provider;
          rounded_corners = cfg.corner.radius > 0;
        };
      };
    };
  };
}
