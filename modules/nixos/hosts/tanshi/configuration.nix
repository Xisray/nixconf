{ self, inputs, ... }: {
  flake.nixosConfigurations.tanshi = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      hostName = "tanshi";
      inherit inputs;
    };
    modules = [
      self.nixosModules.tanshiConfiguration
    ];
  };

  flake.nixosModules.tanshiConfiguration = { pkgs, hostName, ... }: {
    imports = [
      self.nixosModules.tanshiHardware
      self.nixosModules.preferences
      self.nixosModules.general
      self.nixosModules.impermanence
      self.nixosModules.bluetooth
      self.nixosModules.power
      self.nixosModules.fish
      self.nixosModules.nixvim
      self.nixosModules.niri
      #self.nixosModules.firefox
      #self.nixosModules.clashVerge
      #self.nixosModules.syncthing
      #self.nixosModules.keepassxc
      self.nixosModules.home
      self.diskoConfigurations.tanshi
    ];

    preferences.hostName = hostName;

    boot = {
      kernelParams = [ "amd_pstate=active" ];
      loader = {
        grub.enable = true;
        grub.device = "nodev";
        grub.efiSupport = true;
        grub.useOSProber = true;
        efi.canTouchEfiVariables = true;
      };
      initrd.kernelModules = [ "amdgpu" ];
      kernelPackages = pkgs.linuxPackages_latest;
    };

    hardware = {
      cpu.amd.updateMicrocode = true;
      graphics = {
        enable = true;
      };
    };

    system.stateVersion = "26.05";
  };
}
