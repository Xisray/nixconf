{
  flake.nixosModules.qt = {
    lib,
    config,
    pkgs,
    ...
  }: let
    style = config.appearance;
    colors =
      if (style.scheme == null)
      then null
      else
        style.colors {
          src = ./qt.conf.mustache;
        };
    qtctConf = ''
      [Appearance]
      custom_palette=${
        if (colors != null)
        then "true"
        else "false"
      }
      standard_dialogs=default
      style=kvantum
      ${lib.optionalString (style.icons != null) "icon_theme=${style.icons.${style.polarity}}"}
      ${lib.optionalString (colors != null) "color_scheme_path=${colors}"}

      [Fonts]
      general="${style.fonts.sansSerif.name},${toString style.fonts.sizes.applications}"
      fixed="${style.fonts.monospace.name},${toString style.fonts.sizes.applications}"
    '';
  in {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };
    systemd.user.tmpfiles.rules = lib.mkIf (style.scheme != null) [
      "L+ %h/.config/Kvantum/nix/nix.kvconfig - - - - ${style.colors {src = ./kvantum.kvconfig.mustache;}}"
      "L+ %h/.config/Kvantum/nix/nix.svg - - - - ${style.colors {src = ./kvantum.svg.mustache;}}"
      "L+ %h/.config/Kvantum/kvantum.kvconfig - - - - ${pkgs.writeText "kvantum.kvconfig" ''
        [General]
        theme=nix
      ''}"
    ];
    environment = {
      sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_QPA_PLATFORM = "wayland;xcb";
      };
      etc = {
        "xdg/qt5ct/qt5ct.conf".text = qtctConf;
        "xdg/qt6ct/qt6ct.conf".text = qtctConf;
      };
    };
  };
}
