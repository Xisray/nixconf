{ self, ... }: {
  hosts = [ "nixos" ];
  flake.nixosModules.nixosConfiguration = {
    imports = [
      self.nixosModules.nvidia
    ];
    systemd.tpm2.enable = false;
    boot.initrd.systemd.tpm2.enable = false;
    system.stateVersion = "26.05";

    preferences = {
      user.shell = "fish";
      apps.terminal = "kitty";

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
