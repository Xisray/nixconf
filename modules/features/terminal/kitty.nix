{ self, ... }: {
  flake.nixosModules.kitty = { config, pkgs, ... }: {
    preferences.binds."Mod+Return".action = self.packages.${pkgs.stdenv.hostPlatform.system}.kitty;
    home.files.".config/kitty/kitty.conf".text = ''
      include themes/noctalia.conf
      background_opacity ${toString config.preferences.ui.opacity}
    '';
  };
}
