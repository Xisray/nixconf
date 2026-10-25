{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.kitty.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.targets.kitty.enable) {
      homefs.files.".config/kitty/kitty.conf".text = ''
        background_opacity ${toString cfg.opacity.terminal}
        font_family ${cfg.fonts.monospace.name}
        font_size ${toString cfg.fonts.sizes.terminal}
        ${lib.optionalString (cfg.hasScheme) ''
          color0 #${cfg.colors.base01}
          color1 #${cfg.colors.base08}
          color2 #${cfg.colors.base0B}
          color3 #${cfg.colors.base0A}
          color4 #${cfg.colors.base0D}
          color5 #${cfg.colors.base0E}
          color6 #${cfg.colors.base0C}
          color7 #${cfg.colors.base05}
          color8 #${cfg.colors.base03}
          color9 #${cfg.colors.base12}
          color10 #${cfg.colors.base14}
          color11 #${cfg.colors.base13}
          color12 #${cfg.colors.base16}
          color13 #${cfg.colors.base17}
          color14 #${cfg.colors.base15}
          color15 #${cfg.colors.base07}
          cursor #${cfg.colors.base05}
          cursor_text_color #${cfg.colors.base00}
          background #${cfg.colors.base00}
          foreground #${cfg.colors.base05}
          selection_foreground #${cfg.colors.base05}
          selection_background #${cfg.colors.base02}
          active_border_color #${cfg.colors.primary}
          inactive_border_color #${cfg.colors.base01}
          url_color #${cfg.colors.primary}
          active_tab_foreground #${cfg.colors.base00}
          active_tab_background #${cfg.colors.primary}
          inactive_tab_foreground #${cfg.colors.base06}
          inactive_tab_background #${cfg.colors.base01}
          cursor_trail_color #${cfg.colors.base06}
        ''}
      '';
    };
  };
}
