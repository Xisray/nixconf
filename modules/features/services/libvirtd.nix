{
  flake.nixosModules.libvirtd = {pkgs, ...}: {
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
    # environment.systemPackages = [pkgs.spice pkgs.spice-gtk pkgs.spice-protocol pkgs.virt-viewer];
    preferences.persistence.directories = [
      "/var/lib/libvirt"
    ];
    systemd.services.virt-secret-init-encryption.enable = false;
  };
}
