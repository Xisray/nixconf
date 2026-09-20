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
      self.nixosModules.autologin
      self.diskoConfigurations.nixos
    ];
    systemd.tpm2.enable = false;
    boot = {
      initrd.systemd.tpm2.enable = false;
    };
    stylix.opacity = {
      applications = 0.9;
      desktop = 0.9;
      popups = 0.9;
      terminal = 0.9;
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
          port = "DP-2";
          mode = "2560x1440@180.000";
          position = {
            x = 0;
            y = 0;
          };
          primary = true;
        }
        {
          name = "Acer Technologies Acer HS244HQ LS80W0094390";
          mode = "1920x1080@60.000";
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
