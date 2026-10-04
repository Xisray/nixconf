{
  flake.hjemExtraModules.home = {
    pkgs,
    lib,
    config,
    osConfig,
    ...
  }: let
    iniFormat = pkgs.formats.ini {};
  in {
    options.qt = {
      settings = lib.mkOption {
        type = iniFormat.type;
        default = {};
      };
    };
    config = lib.mkIf osConfig.qt.enable {
      qt.settings.Appearance.style = lib.mkForce osConfig.qt.style;
      xdg.config.files = lib.mkIf (config.qt.settings != {}) (let
        settings = iniFormat.generate "qt-settings.conf" config.qt.settings;
      in {
        "qt5ct/qt5ct.conf".source = settings;
        "qt6ct/qt6ct.conf".source = settings;
      });
    };
  };
}
