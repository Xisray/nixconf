{
  flake.nixosModules.preferences = { lib, hostName, ... }: {
    options.preferences = {
      user.name = lib.mkOption {
        type = lib.types.str;
        default = "xisray";
      };
      hostName = lib.mkOption {
        type = lib.types.str;
        default = hostName;
      };
      persistance = {
        nukeRoot.enable = lib.mkEnableOption "Destroy /root on every boot";

        volumeGroup = lib.mkOption {
          default = "btrfs_vg";
          description = ''
            Btrfs volume group name
          '';
        };

        directories = lib.mkOption {
          default = [ ];
          description = ''
            directories to persist
          '';
        };

        files = lib.mkOption {
          default = [ ];
          description = ''
            files to persist
          '';
        };

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
