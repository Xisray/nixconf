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
      blur.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      corner = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        radius = lib.mkOption {
          type = lib.types.int;
          default = 20;
        };
      };
      mouse = {
        accel-profile = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.enum [
              "adaptive"
              "flat"
            ]
          );
          default = null;
          description = "Mouse acceleration profile (null = niri default)";
        };
        accel-speed = lib.mkOption {
          type = lib.types.nullOr (lib.types.float);
          default = null;
          description = "Mouse acceleration speed from -1.0 to 1.0 (null = niri default)";
        };
        natural-scroll = lib.mkOption {
          type = lib.types.nullOr lib.types.bool;
          default = null;
          description = "Invert mouse scroll direction";
        };
        scroll-factor = lib.mkOption {
          type = lib.types.nullOr lib.types.float;
          default = null;
          description = "Scale mouse scroll speed";
        };
      };
      monitors = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
        default = [ ];
        description = "Niri output configurations (per-host)";
        example = [
          {
            name = "Xiaomi Corporation Mi Monitor 5598910068895";
            mode = "2560x1440@180.000";
            position = {
              x = 0;
              y = 0;
            };
          }
        ];
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
