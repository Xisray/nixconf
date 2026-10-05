{
  flake.nixosModules.preferences = {
    lib,
    config,
    ...
  }: {
    options.preferences.monitors = with lib;
      mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
            };
            width = mkOption {
              type = types.int;
            };
            height = mkOption {
              type = types.int;
            };
            refreshRate = mkOption {
              type = types.nullOr types.float;
              default = null;
            };
            primary = mkOption {
              type = types.bool;
              default = false;
            };
            position = mkOption {
              type = types.nullOr (
                types.submodule {
                  options = {
                    x = mkOption {
                      type = types.int;
                      default = 0;
                    };
                    y = mkOption {
                      type = types.int;
                      default = 0;
                    };
                  };
                }
              );
              default = null;
            };
          };
        });
        default = {};
      };
    config = {
      assertions = [
        {
          assertion = config.preferences.monitors != {};
          message = "There must be at least one monitor.";
        }
        {
          assertion = lib.count (m: m.primary) (lib.attrValues config.preferences.monitors) <= 1;
          message = "Only one monitor can be primary";
        }
      ];
    };
  };
}
