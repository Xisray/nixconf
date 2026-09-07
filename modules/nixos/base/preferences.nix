{ self, ... }: {
  flake.nixosModules.preferences = { lib, hostName, ... }: {
    imports = [
      self.sharedModules.preferences
    ];
    options.preferences = {
      user.name = lib.mkOption {
        type = lib.types.str;
        default = "xisray";
      };
      hostName = lib.mkOption {
        type = lib.types.str;
        default = hostName;
      };
      shell = lib.mkOption {
        type = lib.types.enum [
          "fish"
          "zsh"
          "bash"
        ];
        default = "bash";
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
      };
    };
  };
}
