{ self, inputs, ... }: {
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      hostName = "nixos";
      inherit inputs;
    };
    modules = [
      self.nixosModules.nixosConfiguration
    ];
  };

  flake.nixosModules.nixosConfiguration = { hostName, ... }: {
    imports = [
      self.nixosModules.nixosHardware
      self.nixosModules.general
      self.nixosModules.nvidia
      self.nixosModules.bluetooth
      self.nixosModules.niri
      self.nixosModules.clashVerge
      self.nixosModules.syncthing
      self.diskoConfigurations.nixos
    ];

    preferences.hostName = hostName;
    preferences.shell = "fish";

    system.stateVersion = "26.05";
  };
}
