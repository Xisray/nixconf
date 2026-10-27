{
  flake.nixosModules.appearance = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.noctalia.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.noctalia.enable;
    };
    config = lib.mkIf (cfg.targets.noctalia.enable) (let
      paletteName =
        if cfg.hasScheme
        then "nix-${lib.substring 0 8 cfg.schemeHash}"
        else null;
    in {
      environment.etc."noctalia/palettes/${paletteName}.json".text = lib.mkIf cfg.hasScheme (builtins.toJSON {
        ${cfg.polarity} = with cfg.colors.withHashtag; {
          mPrimary = primary;
          mOnPrimary = base00;
          mSecondary = secondary;
          mOnSecondary = base00;
          mTertiary = tertiary;
          mOnTertiary = base00;
          mError = base08;
          mOnError = base00;
          mSurface = base00;
          mOnSurface = base05;
          mSurfaceVariant = base01;
          mOnSurfaceVariant = base06;
          mHover = base02;
          mOnHover = base05;
          mOutline = base03;
          mShadow = base11;
          terminal = {
            foreground = base05;
            background = base00;
            cursor = base05;
            cursorText = base00;
            selectionFg = base05;
            selectionBg = base02;
            normal = {
              black = base01;
              red = base08;
              yellow = base0A;
              green = base0B;
              cyan = base0C;
              blue = base0D;
              magenta = base0E;
              white = base05;
            };
            bright = {
              black = base03;
              red = base12;
              yellow = base13;
              green = base14;
              cyan = base15;
              blue = base16;
              magenta = base17;
              white = base07;
            };
          };
        };
      });
      homefs.files.".config/noctalia/appearance.toml" = (pkgs.formats.toml {}).generate "noctalia-appearance.toml" {
        osd.background_opacity = cfg.opacity.popups;
        notification.background_opacity = cfg.opacity.popups;
        shell.corner_radius_scale = lib.max 0.0 (lib.min 2.0 (cfg.rounding / 12.0));
        shell.panel.transparency_mode =
          if (cfg.opacity.desktop < 1.0)
          then "soft"
          else "solid";
        theme =
          {
            mode = cfg.polarity;
          }
          // lib.optionalAttrs cfg.hasScheme {
            source = "custom";
            custom_palette = paletteName;
          };
      };
    });
  };
}
