{ self, ... }: {
  flake.nixosModules.kitty = { config, pkgs, ... }:
  let
    kitty = (self.packages.${pkgs.stdenv.hostPlatform.system}.kitty or pkgs.kitty);
  in {
    preferences.binds."Mod+Return".action = kitty;
    home.files.".config/kitty/kitty.conf".text = ''
      include themes/noctalia.conf
      background_opacity ${toString config.preferences.ui.opacity}
    '';
    environment.sessionVariables = {
      TERMINAL = lib.getExe kitty;
      TERMCMD = "$TERMINAL";
    };
    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "kitty.desktop" ];
    };
  };
}
