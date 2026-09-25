{ self, ... }: {
  hosts = [ "nixos" ];
  flake.nixosModules.nixosConfiguration = {
    imports = [
      self.nixosModules.nvidia
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.firefox
      self.nixosModules.kitty
      self.nixosModules.clashVerge
      self.nixosModules.syncthing
      self.nixosModules.qbittorrent
      self.nixosModules.keepassxc
      self.nixosModules.yazi
    ];
    systemd.tpm2.enable = false;
    boot.initrd.systemd.tpm2.enable = false;
    system.stateVersion = "26.05";

    preferences = {
      user.shell = "fish";
      mouse = {
        accelProfile = "flat";
        accelSpeed = 0.0;
      };
      monitors = {
        "DP-2" = {
          width = 2560;
          height = 1440;
          position = {
            x = 0;
            y = 0;
          };
          primary = true;
        };
        "HDMI-A-4" = {
          width = 1920;
          height = 1080;
          position = {
            x = 2560;
            y = 0;
          };
        };
      };
    };
  };
}
