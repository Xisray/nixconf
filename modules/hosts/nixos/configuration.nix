{self, ...}: {
  flake.nixosModules.nixos = {pkgs, ...}: {
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
      scheme = "${pkgs.base24-schemes}/share/themes/ayu-mirage.yaml";
      schemeOverrides = {
        primary = "base0A";
        secondary = "base0D";
        tertiary = "base0E";

        # primary = "base0E";
        # secondary = "base07";
        # tertiary = "base15";
      };
      # rounding = 12;
      # blur.enable = true;
      # opacity = {
      #   applications = 0.8;
      #   desktop = 0.8;
      #   popups = 0.8;
      #   terminal = 0.8;
      # };
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 20;
      };
      fonts = {
        # serif = {
        #   package = pkgs.ubuntu-sans;
        #   name = "Ubuntu Sans";
        # };
        # sansSerif = {
        #   package = pkgs.ubuntu-sans;
        #   name = "Ubuntu Sans";
        # };
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
      };
      icons = {
        # package = pkgs.papirus-icon-theme;
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "macchiato";
          accent = "mauve";
        };
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };
    };
  };
}
