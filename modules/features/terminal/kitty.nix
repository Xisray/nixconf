{ self, ... }: {
  flake.nixosModules.kitty = { config, pkgs, lib, ... }:
  let
    kitty = (self.packages.${pkgs.stdenv.hostPlatform.system}.kitty or pkgs.kitty);
  in {
    preferences.binds."Mod+Return".action = kitty;
    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "kitty.desktop" ];
    };
    home = {
      packages = [
        kitty
      ];
      xdg = {
        config.files."kitty/kitty.conf".text = ''
          include themes/noctalia.conf
          background_opacity ${toString config.preferences.ui.opacity}
        '';
        #desktop-entries.kitty = "${kitty}/share/applications/kitty.desktop";
      };
    };
  };
}
