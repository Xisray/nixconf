{
  self,
  pkgs,
  ...
}: {
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
    # scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
    scheme = {
      # base00 = "#282828";
      # base01 = "#3c3836";
      # base02 = "#504945";
      # base03 = "#665c54";
      # base04 = "#928374";
      # base05 = "#ebdbb2";
      # base06 = "#fbf1c7";
      # base07 = "#f9f5d7";
      # base08 = "#cc241d";
      # base09 = "#d65d0e";
      # base0A = "#d79921";
      # base0B = "#98971a";
      # base0C = "#689d6a";
      # base0D = "#458588";
      # base0E = "#b16286";
      # base0F = "#9d0006";
      # base10 = "#2a2520";
      # base11 = "#1d1d1d";
      # base12 = "#fb4934";
      # base13 = "#fabd2f";
      # base14 = "#b8bb26";
      # base15 = "#8ec07c";
      # base16 = "#83a598";
      # base17 = "#d3869b";
      # primary = "base0B";
      # secondary = "base09";
      # tertiary = "base0C";

      base00 = "#24273a";
      base01 = "#1e2030";
      base02 = "#363a4f";
      base03 = "#494d64";
      base04 = "#5b6078";
      base05 = "#cad3f5";
      base06 = "#f4dbd6";
      base07 = "#b7bdf8";
      base08 = "#ed8796";
      base09 = "#f5a97f";
      base0A = "#eed49f";
      base0B = "#a6da95";
      base0C = "#8bd5ca";
      base0D = "#8aadf4";
      base0E = "#c6a0f6";
      base0F = "#f0c6c6";
      base10 = "#1e2030";
      base11 = "#181926";
      base12 = "#ee99a0";
      base13 = "#f4dbd6";
      base14 = "#a6da95";
      base15 = "#91d7e3";
      base16 = "#7dc4e4";
      base17 = "#f5bde6";
      primary = "base0E";
      secondary = "base07";
      tertiary = "base15";
    };
    rounding = 12;
    blur.enable = true;
    opacity = {
      applications = 0.8;
      desktop = 0.8;
      popups = 0.8;
      terminal = 0.8;
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
      # package = pkgs.papirus-icon-theme;
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "macchiato";
        accent = "mauve";
      };
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
  };
}
