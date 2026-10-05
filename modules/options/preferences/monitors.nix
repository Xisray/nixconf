{
  flake.nixosModules.preferences = {lib, ...}: {
    options.preference.monitors = with lib;
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
              type = types.nullOr types.int;
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
  };
}
