{
  flake.nixosModules.appearance = {
    lib,
    config,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.prismlauncher = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      createTheme = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
    config = lib.mkIf (cfg.targets.prismlauncher.enable) {
      homefs.directories.".local/share/PrismLauncher/themes/nix".files = lib.mkIf (cfg.hasScheme && cfg.targets.prismlauncher.createTheme) (with cfg.colors.withHashtag; {
        "theme.json" = {
          value = {
            colors = {
              AlternateBase = base00;
              Base = base01;
              BrightText = base06;
              Button = base02;
              ButtonText = base05;
              Highlight = primary;
              HighlightedText = base00;
              Link = secondary;
              Text = base05;
              ToolTipBase = base11;
              ToolTipText = base05;
              Window = base00;
              WindowText = base05;
              fadeAmount = 0.5;
              fadeColor = base03;
            };
            logColors = {
              Launcher = tertiary;
              Error = base08;
              Warning = base09;
              Debug = base0B;
              FatalHighlight = base08;
              Fatal = base10;
            };
            name = "nix";
            widgets = "Fusion";
          };
          generator = builtins.toJSON;
        };
        "themeStyle.css".text = ''
          QToolTip { 
          	color: ${base05}; 
          	background-color: ${base02};
          	border: 1px solid ${base02};
          }
        '';
      });

      fpatcher.prismlauncher-style = {
        path = ".local/share/PrismLauncher/prismlauncher.cfg";
        format = "ini";
        content.General =
          {
            ConsoleFontSize = cfg.fonts.sizes.terminal;
            IconTheme =
              if cfg.polarity == "dark"
              then "flat_white"
              else "flat";
          }
          // lib.optionalAttrs (cfg.hasScheme && cfg.targets.prismlauncher.createTheme) {
            ApplicationTheme = "nix";
          };
      };
    };
  };
}
