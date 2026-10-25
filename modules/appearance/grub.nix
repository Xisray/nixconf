{
  flake.nixosModules.appearance = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.grub.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.boot.loader.grub.enable;
    };
    config = lib.mkIf (cfg.hasScheme && cfg.targets.grub.enable) (let
      magick = lib.getExe' pkgs.imagemagick "magick";
      mkGrubFont = font: size: name:
        pkgs.runCommand (lib.strings.sanitizeDerivationName "grub-${name}-${toString size}.pf2")
        {
          FONTCONFIG_FILE = pkgs.makeFontsConf {fontDirectories = [font.package];};
        }
        ''
          font=$(${lib.getExe' pkgs.fontconfig "fc-match"} ${lib.escapeShellArg font.name} --format='%{file}')
          ${lib.getExe' pkgs.grub2 "grub-mkfont"} "$font" --name ${lib.escapeShellArg name} --size ${toString size} --output $out
        '';
    in {
      boot.loader.grub = with cfg.colors.withHashtag; {
        splashImage = null;
        backgroundColor = base00;
        font = toString (mkGrubFont cfg.fonts.monospace cfg.fonts.sizes.applications "mono");
        theme = let
          fontSize = cfg.fonts.sizes.applications;
          fontName = "nixsans";
          itemHeight = 36;
          themeTxt = pkgs.writeText "theme.txt" ''
            title-text: ""
            desktop-color: "${base00}"

            terminal-left: "0"
            terminal-top: "0"
            terminal-width: "100%"
            terminal-height: "100%"
            terminal-border: "0"

            + boot_menu {
              left = 50%-240
              top = 35%
              width = 480
              height = 30%
              item_font = "${fontName} Regular ${toString fontSize}"
              item_color = "${base05}"
              icon_width = 32
              icon_height = 32
              item_icon_space = 20
              item_height = ${toString itemHeight}
              item_padding = 5
              item_spacing = 10
              selected_item_color = "${base05}"
              selected_item_pixmap_style = "select_*.png"
            }

            + label {
              top = 70%
              left = 35%
              width = 30%
              align = "center"
              id = "__timeout__"
              text = "Booting in %d seconds"
              font = "${fontName} Regular ${toString fontSize}"
              color = "${base05}"
            }
          '';
          r = cfg.rounding;
          script =
            ''
              mkdir $out
              cp ${themeTxt} $out/theme.txt
              cp ${mkGrubFont cfg.fonts.sansSerif fontSize fontName} $out/sans.pf2

              ${magick} -size 8x${toString itemHeight} xc:'${base02}' png32:$out/select_c.png
            ''
            + lib.optionalString (r > 0) ''
              ${magick} -size ${toString (2 * r)}x${toString itemHeight} xc:none \
                -fill '${base02}' \
                -draw "roundrectangle 0,0 ${toString (2 * r - 1)},${toString (itemHeight - 1)} ${toString r},${toString r}" \
                png32:full.png
              ${magick} full.png -crop ${toString r}x${toString itemHeight}+0+0 +repage png32:$out/select_w.png
              ${magick} full.png -crop ${toString r}x${toString itemHeight}+${toString r}+0 +repage png32:$out/select_e.png
            '';
        in
          pkgs.runCommand "nix-grub" {} script;
      };
    });
  };
}
