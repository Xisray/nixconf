{
  flake.hjemExtraModules.home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    iniFormat = pkgs.formats.ini {};
  in {
    options.gtk = {
      settings = lib.mkOption {
        type = iniFormat.type;
        default = {};
      };
    };
    config = let
      cfg = config.gtk.settings;
    in {
      xdg.config.files = lib.mkIf (cfg != {}) (let
        settings = iniFormat.generate "gtk-settings.ini" {Settings = cfg;};
      in {
        "gtk-3.0/settings.ini".source = settings;
        "gtk-4.0/settings.ini".source = settings;
      });
    };
  };
}
