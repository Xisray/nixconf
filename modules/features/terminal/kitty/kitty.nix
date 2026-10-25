{moduleWithSystem, ...}: {
  flake.nixosModules.kitty = moduleWithSystem ({self', ...}: {
    pkgs,
    config,
    lib,
    ...
  }: let
    kitty = self'.packages.kitty or pkgs.kitty;
    toKittyConf = lib.generators.toKeyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = lib.generators.mkKeyValueDefault {
        mkValueString = v:
          if builtins.isBool v
          then
            (
              if v
              then "yes"
              else "no"
            )
          else lib.generators.mkValueStringDefault {} v;
      } " ";
    };
  in {
    xdg.terminal-exec = {
      enable = true;
      settings.default = ["kitty.desktop"];
    };
    homefs.files.".config/kitty/kitty.conf" = {
      value = {
        font_family = config.appearance.fonts.monospace.name;
        font_size = config.appearance.fonts.sizes.terminal;
        background_opacity = config.appearance.opacity.terminal;
        include = lib.mkIf (config.appearance.scheme != null) (
          config.appearance.colors {
            src = ./kitty.conf.mustache;
          }
        );
      };
      generator = toKittyConf;
    };
    preferences = {
      binds."Mod+Return".action = lib.getExe kitty;
      user.packages = [
        kitty
      ];
    };
  });
}
