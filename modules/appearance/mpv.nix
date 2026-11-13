{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.mpv = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      modernzEnable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
    config = lib.mkIf (cfg.targets.mpv.enable && cfg.hasScheme) {
      homefs.directories.".config/mpv".files = let
        toBGR = hex: let
          clean = lib.removePrefix "#" hex;
          r = builtins.substring 0 2 clean;
          g = builtins.substring 2 2 clean;
          b = builtins.substring 4 2 clean;
        in "${b}${g}${r}";
      in {
        "theme.conf".text = with cfg.colors; ''
          background-color='#${base00}'
          osd-back-color='#${base01}'
          osd-border-color='#${base01}'
          osd-color='#${base05}'
          osd-shadow-color='#${base00}'

          script-opts-append=stats-border_color=${toBGR base01}
          script-opts-append=stats-font_color=${toBGR base05}
          script-opts-append=stats-plot_bg_border_color=${toBGR primary}
          script-opts-append=stats-plot_bg_color=${toBGR base01}
          script-opts-append=stats-plot_color=${toBGR primary}

          script-opts-append=uosc-color=foreground=${primary},foreground_text=${base02},background=${base00},background_text=${base05},curtain=${base01},success=${base0B},error=${base08}
        '';
        "script-opts/modernz.conf".text = lib.mkIf (cfg.targets.mpv.modernzEnable) (with cfg.colors.withHashtag; ''
          osc_color=${base00}
          window_title_color=${base05}
          window_controls_color=${base05}
          windowcontrols_close_hover=${base08}
          windowcontrols_max_hover=${base0A}
          windowcontrols_min_hover=${base0B}
          title_color=${base05}
          seekbar_cache_color=${base04}
          seekbarfg_color=${primary}
          seekbarbg_color=${base03}
          seek_handle_color=${secondary}
          seek_handle_border_color=${primary}
          time_color=${base05}
          chapter_title_color=${base05}
          cache_info_color=${base04}
          side_buttons_color=${base05}
          middle_buttons_color=${base05}
          playpause_color=${base05}
          held_element_color=${base04}
          hover_effect_color=${primary}
          thumbnail_box_color=${base01}
          thumbnail_box_outline=${base03}
          nibble_color=${primary}
          nibble_current_color=${base05}
          ab_loop_color=${tertiary}
        '');
      };
    };
  };
}
