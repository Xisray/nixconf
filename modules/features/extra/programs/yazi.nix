{
  flake.hjemExtraModules.programs = {
    lib,
    pkgs,
    config,
    ...
  }: let
    tomlFormat = pkgs.formats.toml {};
    tomlOption = lib.mkOption {
      inherit (tomlFormat) type;
      default = {};
    };
  in {
    options.programs.yazi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.yazi;
      };
      settings = tomlOption;
      theme = tomlOption;
      vfs = tomlOption;
      keymap = tomlOption;
      initLua = lib.mkOption {
        type = with lib.types; nullOr (either path lines);
        default = null;
      };
    };

    config = let
      cfg = config.programs.yazi;
    in
      lib.mkIf cfg.enable {
        packages = [
          cfg.package
        ];
        xdg.config.files = {
          "yazi/yazi.toml" = lib.mkIf (cfg.settings != {}) {
            source = tomlFormat.generate "yazi-settings" cfg.settings;
          };
          "yazi/theme.toml" = lib.mkIf (cfg.theme != {}) {
            source = tomlFormat.generate "yazi-theme" cfg.theme;
          };
          "yazi/vfs.toml" = lib.mkIf (cfg.vfs != {}) {
            source = tomlFormat.generate "yazi-vfs" cfg.vfs;
          };
          "yazi/keymap.toml" = lib.mkIf (cfg.keymap != {}) {
            source = tomlFormat.generate "yazi-keymap" cfg.keymap;
          };
          "yazi/init.lua" = lib.mkIf (cfg.initLua != null) (
            if builtins.isPath cfg.initLua
            then {source = cfg.initLua;}
            else {text = cfg.initLua;}
          );
        };
      };
  };
}
