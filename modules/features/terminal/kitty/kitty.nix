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
        (
          if config.appearance.scheme == null
          then self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
          else
            kittyWrapper.wrap {
              inherit pkgs;
              extraConfig = "include ${config.appearance.colors {
                template =
                  ./${
                    if config.appearance.base24
                    then "base24"
                    else "base16"
                  }.conf.mustache;
                extension = ".conf";
              }}";
            }
        );
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
