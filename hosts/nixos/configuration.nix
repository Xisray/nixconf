{self, pkgs, ...}: {
  imports = [
    self.nixosModules.common
    self.nixosModules.nvidia
    self.nixosModules.bluetooth
  ];
  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;
  system.stateVersion = "26.05";
  preferences = {
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

  appearance = {
    scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
  };
}
