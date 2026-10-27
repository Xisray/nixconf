{self, ...}: {
  imports = [self.diskoConfigurations.main];
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-INTEL_SSDPEKNU512GZ_PHKA212405AX512A";
    content = {
      partitions = {
        efi.size = "2G";
        swap.size = "16G";
        root.size = "100%";
      };
    };
  };
}
