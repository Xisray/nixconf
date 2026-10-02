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
    home.xdg.config.files =
      lib.mkIf config.qt.enable
      (let
        provider = config.preferences.theme.provider;
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
        dropNulls = lib.filterAttrs (_: v: v != null);

        qtctSettings = {
          Appearance = dropNulls {
            color_scheme_path =
              if provider == null
              then null
              else "./colors/${provider}.conf";
            custom_palette = true;
            standard_dialogs = "default";
            style = config.qt.style;
          };
          Fonts = dropNulls {
            fixed = mkFont mono 12;
            general = mkFont sans 12;
          };
        };

        qtctConf = lib.generators.toINI {} qtctSettings;
      in {
        "qt5ct/qt5ct.conf".text = qtctConf;
        "qt6ct/qt6ct.conf".text = qtctConf;
      });
  };
}
