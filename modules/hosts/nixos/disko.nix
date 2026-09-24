{ self, ... }: {
  flake.diskoConfigurations.nixos = {
    imports = [
      self.diskoConfigurations.default
    ];
    disko.devices.disk.main = {
      device = "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B7785A5A1EA";
      content.partitions = {
        efi.size = "2G";
        swap.size = "16G";
        root.size = "100%";
      };
    };
  };
}
