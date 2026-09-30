{
  flake.nixosModules.qt = {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };
    environment.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };
}
