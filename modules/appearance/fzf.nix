{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.fzf.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    config = lib.mkIf (cfg.targets.fzf.enable) {
      homefs.files = let
        border =
          if config.appearance.rounding == 0
          then "sharp"
          else "rounded";
        opts = lib.concatStringsSep " " (
          lib.optionals (config.appearance.hasScheme) (
            with config.appearance.colors.withHashtag; [
              "--color=bg+:${base01},bg:${base00},spinner:${base05},hl:${base08}"
              "--color=fg:${base05},header:${base08},info:${primary},pointer:${base05}"
              "--color=marker:${base06},fg+:${base05},prompt:${primary},hl+:${base08}"
              "--color=selected-bg:${base01}"
              "--color=border:${base02},label:${base05}"
            ]
          )
          ++ [
            "--border=${border}"
            "--preview-window=border-${border}"
          ]
        );
      in {
        ".config/fish/conf.d/fzf.fish".text = lib.mkIf config.programs.fish.enable ''
          set -gx FZF_DEFAULT_OPTS (string join ' ' -- $FZF_DEFAULT_OPTS '${opts}' | string collect)
        '';
      };
    };
  };
}
