{ self, ... }: {
  flake.nixosModules.kitty =
    {
      config,
      pkgs,
      ...
    }:
    let
      kitty = self.packages.${pkgs.stdenv.hostPlatform.system}.kitty or pkgs.kitty;
    in
    {
      preferences.binds."Mod+Return".action = kitty;
      xdg.terminal-exec = {
        enable = true;
        settings.default = [ "kitty.desktop" ];
      };
      home.programs.kitty = {
        enable = true;
        package = kitty;
        includes = [ "themes/${config.preferences.theme.provider}.conf" ];
        settings.background_opacity = config.preferences.theme.opacity;
      };
    };
}
