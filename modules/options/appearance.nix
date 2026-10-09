{inputs, ...}: {
  flake.nixosModules.preferences = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.appearance = with lib; {
      scheme = mkOption {
        type = with types; oneOf [path lines attrs];
        default = null;
        example = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
        description = "Base16 scheme (path to yaml, yaml string, or attrs)";
      };
      colors = mkOption {
        type = types.attrs;
        readOnly = true;
        description = "Processed scheme with base00..base0F, withHashtag, etc.";
      };
      base24 = mkEnableOption "Use base24 instead base16";
      polarity = mkOption {
        type = types.enum ["dark" "light"];
        default = "dark";
      };
      cursor = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
            };
            package = mkOption {
              type = types.package;
            };
            size = mkOption {
              type = types.int;
              default = 24;
            };
          };
        });
        default = null;
      };
      opacity = {
        terminal = mkOption {
          type = types.float;
          default = 1.0;
        };
        applications = mkOption {
          type = types.float;
          default = 1.0;
        };
        popups = mkOption {
          type = types.float;
          default = 1.0;
        };
        desktop = mkOption {
          type = types.float;
          default = 1.0;
        };
      };
      icons = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            dark = mkOption {
              type = types.str;
            };
            light = mkOption {
              type = types.str;
            };
            package = mkOption {
              type = types.package;
            };
          };
        });
        default = null;
      };
      rounding = mkOption {
        type = types.int;
        default = 0;
      };
      blur = {
        enable = mkEnableOption "enable blur";
        size = mkOption {
          type = types.ints.positive;
          default = 8;
        };
        passes = mkOption {
          type = types.ints.positive;
          default = 3;
        };
        noise = mkOption {
          type = types.float;
          default = 0.02;
        };
        saturation = mkOption {
          type = types.float;
          default = 1.0;
        };
      };
      fonts = let
        mkFontOption = defName: defPackage: {
          name = mkOption {
            type = types.str;
            default = defName;
          };
          package = mkOption {
            type = types.package;
            default = defPackage;
          };
        };
      in {
        packages = mkOption {
          type = types.listOf types.package;
          default = [];
        };
        emoji = mkFontOption "Noto Color Emoji" pkgs.noto-fonts-color-emoji;
        monospace = mkFontOption "DejaVu Sans Mono" pkgs.dejavu_fonts;
        sansSerif = mkFontOption "DejaVu Sans" pkgs.dejavu_fonts;
        serif = mkFontOption "DejaVu Serif" pkgs.dejavu_fonts;
        sizes = {
          applications = mkOption {
            type = types.ints.positive;
            default = 12;
          };
          desktop = mkOption {
            type = types.ints.positive;
            default = 10;
          };
          popups = mkOption {
            type = types.ints.positive;
            default = 10;
          };
          terminal = mkOption {
            type = types.ints.positive;
            default = 12;
          };
        };
      };
    };
    config = let
      cfg = config.appearance;
    in {
      appearance.colors = lib.mkIf (cfg.scheme != null) ((pkgs.callPackage inputs.base16.lib {}).mkSchemeAttrs cfg.scheme);
      environment.systemPackages = lib.optional (cfg.icons != null) cfg.icons.package ++ lib.optional (cfg.cursor != null) cfg.cursor.package;
      environment.sessionVariables = lib.mkIf (cfg.cursor != null) {
        XCURSOR_THEME = cfg.cursor.name;
        XCURSOR_SIZE = cfg.cursor.size;
      };
      fonts = {
        packages = cfg.fonts.packages ++ cfg.fonts.emoji.package ++ cfg.fonts.monospace.package ++ cfg.fonts.sansSerif.package ++ cfg.fonts.serif.package;
        fontconfig = {
          enable = true;
          defaultFonts = {
            emoji = [cfg.fonts.emoji.name];
            monospace = [cfg.fonts.monospace.name];
            sansSerif = [cfg.fonts.sansSerif.name];
            serif = [cfg.fonts.serif.name];
          };
        };
      };
    };
  };
}
