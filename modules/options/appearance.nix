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
        terminal = lib.mkOption {
          type = types.float;
          default = 1.0;
        };
        applications = lib.mkOption {
          type = types.float;
          default = 1.0;
        };
        popups = lib.mkOption {
          type = types.float;
          default = 1.0;
        };
        desktop = lib.mkOption {
          type = types.float;
          default = 1.0;
        };
      };
      icons = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
            };
            package = mkOption {
              type = types.package;
            };
          };
        });
        default = null;
      };
      rounding = lib.mkOption {
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
    };
    config = let
      cfg = config.appearance;
    in {
      appearance.colors = lib.mkIf (cfg.scheme != null) ((pkgs.callPackage inputs.base16.lib {}).mkSchemeAttrs cfg.scheme);
    };
  };
}
