{
  flake.nixosModules.theme = {lib, ...}: let
    targetType = lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };
    };
    themeType = lib.types.submodule {
      options = {
        provider = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
        targets = lib.mkOption {
          type = lib.types.attrsOf targetType;
          default = {};
        };
        opacity = lib.mkOption {
          type = lib.types.float;
          default = 1.0;
        };
        blur.enable = lib.mkEnableOption "Enable blur effect";
        corner.radius = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };
        autoEnable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };
    };
  in {
    options.preferences.theme = lib.mkOption {
      type = themeType;
      default = {};
    };
  };
}
