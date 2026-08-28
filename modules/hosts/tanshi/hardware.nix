{ self, inputs, ... }: {
  flake.nixosModules.tanshiHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
  
    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];
  
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/0cd2663b-de67-4d6e-8f94-ee8558842de9";
      fsType = "ext4";
    };
  
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/729B-AD6F";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  
    swapDevices = [
      { device = "/dev/disk/by-uuid/dce04076-bb85-48db-a9f8-97e755e0e591"; }
    ];
  
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
