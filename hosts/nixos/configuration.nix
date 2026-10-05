{
  imports = [];
  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;
  system.stateVersion = "26.05";
}
