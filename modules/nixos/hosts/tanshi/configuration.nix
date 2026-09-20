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
      self.nixosModules.qbittorrent
      self.nixosModules.autologin
      self.diskoConfigurations.tanshi
    ];

    preferences = {
      hostName = hostName;
      shell = "fish";
      monitors = [
        {
          name = "Chimei Innolux Corporation 0x1512 Unknown";
          port = "eDP-1";
          mode = "1920x1080@60.001";
          position = {
            x = 0;
            y = 0;
          };
          primary = true;
        }
      ];
      blur.enable = false;
    };

    stylix.opacity = {
      applications = 0.9;
      desktop = 0.9;
      popups = 0.9;
      terminal = 0.9;
    };

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
