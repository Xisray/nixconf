{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.qt.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.targets.qt.enable) {
      qt = {
        enable = true;
        platformTheme = "qt5ct";
        style = "kvantum";
      };
      homefs = let
        colors =
          if (cfg.scheme == null)
          then null
          else cfg.colors {src = ./qt.conf.mustache;};
        qtctConf = ''
          [Appearance]
          custom_palette=${
            if (colors != null)
            then "true"
            else "false"
          }
          standard_dialogs=default
          style=kvantum
          ${lib.optionalString (cfg.icons != null) "icon_theme=${cfg.icons.${cfg.polarity}}"}
          ${lib.optionalString (colors != null) "color_scheme_path=${colors}"}

          [Fonts]
          general="${cfg.fonts.sansSerif.name},${toString cfg.fonts.sizes.applications}"
          fixed="${cfg.fonts.monospace.name},${toString cfg.fonts.sizes.applications}"
        '';
      in {
        files = {
          ".config/qt5ct/qt5ct.conf".text = qtctConf;
          ".config/qt6ct/qt6ct.conf".text = qtctConf;
        };
        directories.".config/Kvantum" = lib.mkIf cfg.hasScheme {
          directories.nix.files = {
            "nix.kvconfig" = cfg.colors {src = ./kvantum.kvconfig.mustache;};
            "nix.svg" = cfg.colors {src = ./kvantum.svg.mustache;};
          };
          files."kvantum.kvconfig".text = ''
            [General]
            theme=nix
          '';
        };
      };
    };
  };
}
