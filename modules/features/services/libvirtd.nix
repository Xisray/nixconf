{
  flake.nixosModules.libvirtd = {pkgs, config, ...}: {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
          vhostUserPackages = [pkgs.virtiofsd];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    programs.virt-manager.enable = true;
    user.extraGroups = ["libvirtd" "kvm"];
    preferences.persistence.directories = [
      "/var/lib/libvirt"
    ];
    systemd.services.virt-secret-init-encryption.enable = config.systemd.tpm2.enable;
  };
}
