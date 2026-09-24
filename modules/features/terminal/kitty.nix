{ self, ... }: {
  flake.nixosModules.kitty = { config, pkgs, ... }: {
    preferences.binds."Mod+Return".action = self.packages.${pkgs.stdenv.hostPlatform.system}.kitty;
    home.".config/kitty/dynamic.conf".text = ''
      background_opacity ${config.preferences.ui.opacity}
    '';
  };
}
