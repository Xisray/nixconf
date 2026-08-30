{ self, inputs, ... }: {
  flake.nixosModules.stylix = { pkgs, ... }: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = {
        scheme = self.themeName;
        author = "";
        slug = self.themeName;
      }
      // self.themeNoHash;
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
    };
  };
}
