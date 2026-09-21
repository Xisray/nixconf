{ lib, config, ... }:
let
  listOfStrings =
    description:
    lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = description;
    };

  bindActionType = lib.types.either lib.types.str lib.types.package;
  bindsType = lib.types.submodule {
    options = {
      action = lib.mkOption {
        type = lib.types.either bindActionType (lib.types.listOf bindActionType);
      };
      allowLocked = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = "Разрешать ли выполнение при заблокированном экране";
      };
    };
  };

  monitorType = lib.types.submodule {
    options = {
      enabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      width = lib.mkOption {
        type = lib.types.int;
      };
      height = lib.mkOption {
        type = lib.types.int;
      };
      refreshRate = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
      primary = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      position = lib.mkOption {
        type = lib.types.nullOr lib.types.submodule {
          options = {
            x = lib.mkOption {
              type = lib.types.int;
              default = 0;
            };
            y = lib.mkOption {
              type = lib.types.int;
              default = 0;
            };
          };
        };
        default = null;
      };
    };
  };
in
{
  options.preferences = {
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "xisray";
      };
      shell = lib.mkOption {
        type = lib.types.enum [
          "fish"
          "bash"
          "zsh"
        ];
      };
    };
    ui = {
      opacity = lib.mkOption {
        type = lib.types.float;
        default = 1.0;
      };
      blur.enable = lib.mkEnableOption "Enable blur effect";
      corner.radius = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };
    };
    binds = lib.mkOption {
      type = lib.types.attrsOf bindsType;
      default = { };
      description = "Список/набор биндингов с параметрами";
    };
    monitors = lib.mkOption {
      type = lib.types.attrsOf monitorType;
    };
    mouse = {
      accelProfile = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "adaptive"
            "flat"
          ]
        );
        default = null;
        description = "Mouse acceleration profile (null = default)";
      };
      accelSpeed = lib.mkOption {
        type = lib.types.nullOr (lib.types.float);
        default = null;
        description = "Mouse acceleration speed from -1.0 to 1.0 (null = default)";
      };
      naturalScroll = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = "Invert mouse scroll direction";
      };
      scrollFactor = lib.mkOption {
        type = lib.types.nullOr lib.types.float;
        default = null;
        description = "Scale mouse scroll speed";
      };
    };
    wm.rules = {
      windows = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };
      layers = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };
    };
    persistence = {
      nukeRoot.enable = lib.mkEnableOption "Destroy /root on every boot";
      volumeGroup = lib.mkOption {
        default = "btrfs_vg";
        description = "Btrfs volume group name";
      };
      directories = listOfStrings "System directories to persist";
      files = listOfStrings "System files to persist";
      data = {
        directories = listOfStrings "Persistent user data directories";
        files = listOfStrings "Persistent user data files";
      };
      cache = {
        directories = listOfStrings "Persistent cache directories";
        files = listOfStrings "Persistent cache files";
      };
    };
    apps = {
      terminal = lib.mkOption {
        type =
          let
            terminals = builtins.attrNames config.flake.terminals;
          in
          lib.types.enum terminals;
      };
    };
  };
  config.assertions = [
    {
      assertion = config.preferences.monitors != { };
      message = "preferences.monitors должен содержать хотя бы один монитор";
    }
  ];
}
