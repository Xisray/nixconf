{
  flake.diskoConfigurations.default = {
    disko.devices = {
      disk.main = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            efi = {
              name = "SYSTEM";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              name = "root";
              content = {
                type = "lvm_pv";
                vg = "btrfs_vg";
              };
            };
          };
        };
      };
      nodev = {
        "/" = {
          fsType = "tmpfs";
          mountOptions = [
            "size=25%"
            "mode=755"
          ];
        };
      };
      lvm_vg = {
        btrfs_vg = {
          type = "lvm_vg";
          lvs = {
            root = {
              size = "100%FREE";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];

                subvolumes = {
                  "/root" = {
                  };

                  "/persist" = {
                    mountOptions = [
                      "subvol=persist"
                      "noatime"
                    ];
                    mountpoint = "/persist";
                  };

                  "/nix" = {
                    mountOptions = [
                      "subvol=nix"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
