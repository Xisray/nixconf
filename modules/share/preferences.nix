{
  flake.sharedModules.preferences = { lib, ... }: {
    options.preferences = {
      autostart = lib.mkOption {
        type = lib.types.listOf (lib.types.either lib.types.str lib.types.package);
        default = [ ];
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
