{
  flake.nixosModules.qt = {
    config,
    lib,
    ...
  }: {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };
    environment.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_QPA_PLATFORM = "wayland;xcb";
    };
    home.qt.settings = let
      theme = config.preferences.theme;
      fonts = config.fonts.fontconfig.defaultFonts;
      firstOrNull = list:
        if list == []
        then null
        else builtins.head list;
      mono = firstOrNull fonts.monospace;
      sans = firstOrNull fonts.sansSerif;
      mkFont = name: size:
        if name == null
        then null
        else ''"${name},${toString size}"'';
    in {
      Appearance =
        {
          custom_palette = true;
          standard_dialogs = "default";
        }
        // lib.optionalAttrs (theme.provider != null) {
          color_scheme_path = "./colors/${theme.provider}.conf";
        };
      Fonts =
        {
        }
        // lib.optionalAttrs (sans != null) {
          general = mkFont sans 12;
        }
        // lib.optionalAttrs (mono != null) {
          fixed = mkFont mono 12;
        };
    };
  };
}
