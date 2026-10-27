{self, ...}: {
  flake.nixosModules.tanshi = {pkgs, ...}: {
    imports = [self.nixosModules.laptop];

    system.stateVersion = "26.05";
    boot = {
      kernelParams = ["amd_pstate=active"];
      initrd.kernelModules = ["amdgpu"];
    };
    hardware = {
      graphics = {
        enable = true;
      };
    };

    preferences.monitors."eDP-1" = {
      width = 1920;
      height = 1080;
      position = {
        x = 0;
        y = 0;
      };
      primary = true;
    };

    appearance = {
      scheme = "${pkgs.base24-schemes}/share/themes/ayu-mirage.yaml";
      schemeOverrides = {
        primary = "base0A";
        secondary = "base0D";
        tertiary = "base0E";
      };
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
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };
    };
  };
}
