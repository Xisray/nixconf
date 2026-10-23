{self, ...}: {
  flake.nixosModules.kitty = {
    pkgs,
    config,
    lib,
    ...
  }: let
    kittyWrapper = self.wrappers.kitty or null;
    kitty =
      if kittyWrapper == null
      then pkgs.kitty
      else
        (kittyWrapper.wrap {
          inherit pkgs;
          settings.background_opacity = config.appearance.opacity.terminal;
          font = {
            name = config.appearance.fonts.monospace.name;
            size = config.appearance.fonts.sizes.terminal;
          };
          extraConfig = lib.mkIf (config.appearance.scheme != null) "include ${config.appearance.colors {
            src = ./kitty.conf.mustache;
          }}";
        });
  in {
    xdg.terminal-exec = {
      enable = true;
      settings.default = ["kitty.desktop"];
    };
    preferences = {
      binds."Mod+Return".action = lib.getExe kitty;
      user.packages = [
        kitty
      ];
    };
  };
}
