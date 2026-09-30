{self, ...}: {
  hosts = ["nixos"];
  flake.nixosModules.nixosConfiguration = {pkgs, ...}: {
    imports = [
      self.nixosModules.nvidia
      self.nixosModules.bluetooth
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.firefox
      self.nixosModules.kitty
      self.nixosModules.clashVerge
      self.nixosModules.syncthing
      self.nixosModules.qbittorrent
      self.nixosModules.keepassxc
      self.nixosModules.yazi
      self.nixosModules.cliamp
    ];
    systemd.tpm2.enable = false;
    boot.initrd.systemd.tpm2.enable = false;
    system.stateVersion = "26.05";

    preferences = {
      user.shell = "fish";
      theme = {
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 20;
        };
      };
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
