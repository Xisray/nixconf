{self, ...}: {
  imports = [
    self.nixosModules.common
    self.nixosModules.nvidia
    self.nixosModules.bluetooth
  ];
  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;
  system.stateVersion = "26.05";
}
