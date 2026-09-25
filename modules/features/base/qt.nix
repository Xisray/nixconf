{
  flake.nixosModules.qt = {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };
  };
}
