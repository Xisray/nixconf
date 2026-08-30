{ self, inputs, ... }: {
  flake.nixosModules.noctaliaGreeter = { config, ... }: {
    imports = [
      inputs.noctalia-greeter.nixosModules.default
    ];
    programs.noctalia-greeter = {
      enable = true;
      settings = {
        session.defafult = "niri";
        user.default = config.preferences.user.name;
        appearance = {
          scheme = "Synced";
          password_style = "random";
          hide_logo = true;
          corener_radius_scale = 0;
          font_family = builtins.head config.fonts.fontconfig.defaultFonts.sansSerif;
          palette = {
            primary = self.theme.base07;
            on_primary = self.theme.base00;
            secondary = self.theme.base06; # ?
            on_secondary = self.theme.base00;
            tertiary = self.theme.base0E;
            on_tertiary = self.theme.base00;
            error = self.theme.base08;
            on_error = self.theme.base00;
            surface = self.theme.base00;
            on_surface = self.theme.base05;
            surface_variant = self.theme.base02;
            on_surface_variant = self.theme.base04; # ?
            outline = self.theme.base03; # ?
            shadow = self.theme.base01; # ?
            hover = self.theme.base03;
            on_hover = self.theme.base05;
          };
        };
      };
    };
  };
}
