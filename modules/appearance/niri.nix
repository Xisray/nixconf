{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.niri.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.targets.niri.enable) {
      homefs.files.".config/niri/config.kdl".text = ''
        window-rule {
          ${lib.optionalString (cfg.rounding > 0) ''
          geometry-corner-radius ${toString cfg.rounding}
          clip-to-geometry true
        ''}
          ${lib.optionalString (cfg.blur.enable) ''
          background-effect {
            blur true
          }
        ''}
        }
        blur {
        ${
          if cfg.blur.enable
          then ''
            passes ${toString cfg.blur.passes}
            offset ${toString cfg.blur.size}
            noise ${toString cfg.blur.noise}
            saturation ${toString cfg.blur.saturation}
          ''
          else ''
            off
          ''
        }
        }
        ${lib.optionalString (cfg.cursor != null) ''
          cursor {
            xcursor-theme "${cfg.cursor.name}"
            xcursor-size ${toString cfg.cursor.size}
          }
        ''}
        ${lib.optionalString (cfg.hasScheme) ''
          layout {
            focus-ring {
              active-color "#${cfg.colors.primary}"
              inactive-color "#${cfg.colors.base00}"
              urgent-color "#${cfg.colors.base08}"
            }
            border {
              active-color "#${cfg.colors.primary}"
              inactive-color "#${cfg.colors.base00}"
              urgent-color "#${cfg.colors.base08}"
            }
            tab-indicator {
              active-color "#${cfg.colors.primary}"
              inactive-color "#${cfg.colors.base00}"
              urgent-color "#${cfg.colors.base08}"
            }
            insert-hint {
              color "#${cfg.colors.primary}"
            }
          }
          recent-windows {
            highlight {
              active-color "#${cfg.colors.primary}"
              urgent-color "#${cfg.colors.base08}"
            }
          }
        ''}
      '';
    };
  };
}
