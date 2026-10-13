{self, ...}: {
  flake.nixosModules.telegram = {
    pkgs,
    lib,
    config,
    ...
  }: let
    dataDir = ".local/share/AyuGramDesktop";
    package = pkgs.ayugram-desktop;

    theme =
      if (config.appearance.scheme != null)
      then (config.appearance.colors {src = ./telegram.tdesktop-theme.mustache;})
      else null;

    telegram =
      if self ? wrappers.telegram
      then
        self.wrappers.telegram.wrap {
          inherit pkgs package theme;
          tdata = "${dataDir}/tdata";
          background =
            if (config.appearance.scheme != null)
            then config.appearance.colors.base00
            else null;
        }
      else lib.warn "wrappers.telegram not found, theme will not be applied" package;
  in {
    preferences = {
      user.packages = [
        telegram
      ];
      persistence.data.directories = [
        dataDir
      ];
    };
  };
}
