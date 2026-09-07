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

  flake.nixosModules.tanshiConfiguration = { hostName, ... }: {
    imports = [
      self.nixosModules.tanshiHardware
      self.nixosModules.general
      self.nixosModules.bluetooth
      self.nixosModules.power
      self.nixosModules.niri
      self.nixosModules.clashVerge
      self.nixosModules.syncthing
      self.diskoConfigurations.tanshi
    ];

    preferences.hostName = hostName;
    preferences.shell = "fish";

    boot = {
      kernelParams = [ "amd_pstate=active" ];
      initrd.kernelModules = [ "amdgpu" ];
    };

    hardware = {
      graphics = {
        enable = true;
      };
    };

    system.stateVersion = "26.05";
  };
}
