{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.fish.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.hasScheme && cfg.targets.fish.enable) {
      homefs.files.".config/fish/conf.d/theme.fish".text = ''
        set -U fish_color_normal normal
        set -U fish_color_command ${cfg.colors.primary}
        set -U fish_color_keyword ${cfg.colors.secondary}
        set -U fish_color_quote green
        set -U fish_color_redirection brblue
        set -U fish_color_end normal
        set -U fish_color_error brred
        set -U fish_color_param brcyan
        set -U fish_color_valid_path --underline
        set -U fish_color_option brcyan --italics
        set -U fish_color_comment ${cfg.colors.base03}
        set -U fish_color_selection ${cfg.colors.base06} --background=${cfg.colors.base02}
        set -U fish_color_operator ${cfg.colors.secondary}
        set -U fish_color_escape ${cfg.colors.base09}
        set -U fish_color_autosuggestion ${cfg.colors.base03}
        set -U fish_color_cwd ${cfg.colors.primary}
        set -U fish_color_cwd_root red
        set -U fish_color_user brgreen
        set -U fish_color_host normal
        set -U fish_color_host_remote normal
        set -U fish_color_status red
        set -U fish_color_cancel -r
        set -U fish_color_search_match ${cfg.colors.primary} --background=${cfg.colors.base02}
        set -U fish_color_history_current --underline=curly
        set -U fish_pager_color_progress ${cfg.colors.base01} --background=${cfg.colors.primary}
        set -U fish_pager_color_background --background=${cfg.colors.base00}
        set -U fish_pager_color_prefix ${cfg.colors.primary} --bold --italics
        set -U fish_pager_color_completion normal
        set -U fish_pager_color_description ${cfg.colors.base09}
        set -U fish_pager_color_selected_background --background=${cfg.colors.base02}
        set -U fish_pager_color_selected_prefix ${cfg.colors.primary} --bold --italics --background=${cfg.colors.base02}
        set -U fish_pager_color_selected_completion normal
        set -U fish_pager_color_description ${cfg.colors.base09}
      '';
    };
  };
}
