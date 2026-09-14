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
      self.nixosModules.qbittorrent
      self.diskoConfigurations.nixos
    ];
    systemd.tpm2.enable = false;
    boot = {
      initrd.systemd.tpm2.enable = false;
    };

    preferences = {
      hostName = hostName;
      shell = "fish";
      mouse = {
        accel-profile = "flat";
        accel-speed = 0.0;
      };
      monitors = [
        {
          name = "Xiaomi Corporation Mi Monitor 5598910068895";
          mode = "2560x1440@180.000";
          position = {
            x = 0;
            y = 0;
          };
        }
        {
          name = "Acer Technologies Acer HS244HQ LS80W0094390";
          mode = "1920x1080@60.000";
          #modeline = "285.25  1920 1968 2000 2080  1080 1083 1088 1144 +hsync -vsync";
          position = {
            x = 2560;
            y = 0;
          };
        }
      ];
    };

    system.stateVersion = "26.05";
  };
}
