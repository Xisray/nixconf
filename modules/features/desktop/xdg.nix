{
  flake.nixosModules.xdg = {
    config,
    lib,
    ...
  }: {
    xdg = {
      portal.enable = true;
      mime.enable = true;
      icons.fallbackCursorThemes = lib.mkIf (config.appearance.cursor != null) [
        config.appearance.cursor.name
      ];
    };
  };
}
