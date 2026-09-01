{
  flake.sharedModules.preferences = { lib, ... }: {
    options.preferences = {
      autostart = lib.mkOption {
        type = lib.types.listOf (lib.types.either lib.types.str lib.types.package);
        default = [ ];
      };
      binds = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              action = lib.mkOption {
                type = lib.types.either (lib.types.listOf lib.types.str) lib.types.str;
              };
              props = lib.mkOption {
                type = lib.types.attrsOf lib.types.anything;
                default = { };
              };
            };
          }
        );
        default = { };
      };
      persistance = {
        data.directories = lib.mkOption {
          default = [ ];
          description = ''
            directories to persist
          '';
        };

        data.files = lib.mkOption {
          default = [ ];
          description = ''
            files to persist
          '';
        };

        cache.directories = lib.mkOption {
          default = [ ];
          description = ''
            directories to persist
          '';
        };

        cache.files = lib.mkOption {
          default = [ ];
          description = ''
            files to persist
          '';
        };
      };
    };
  };
}
