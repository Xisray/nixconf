{ inputs, ... }: {
  flake.nixosModules.stylix = { pkgs, ... }: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 20;
      };
      fonts = {
        serif = {
          package = pkgs.ubuntu-sans;
          name = "Ubuntu Sans";
        };
        sansSerif = {
          package = pkgs.ubuntu-sans;
          name = "Ubuntu Sans";
        };
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
      };
      opacity = {
        applications = 0.8;
        desktop = 0.8;
        popups = 0.8;
        terminal = 0.8;
      };
    };
  };
}
