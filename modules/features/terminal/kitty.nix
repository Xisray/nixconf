{ self, ... }: {
  flake.nixosModules.kitty = { config, pkgs, ... }: {
    preferences.binds."Mod+Return".action = self.packages.${pkgs.stdenv.hostPlatform.system}.kitty;
    home.files.".config/kitty/dynamic.conf".text = ''
      background_opacity ${toString config.preferences.ui.opacity}
    '';
  };
}
