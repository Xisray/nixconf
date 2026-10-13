{
  flake.shellModules.fzf = {
    wlib,
    lib,
    appearance,
    pkgs,
    ...
  }: {
    packages.fzf = lib.mkIf (appearance.scheme != null) (wlib.wrapPackage {
      inherit pkgs;
      package = pkgs.fzf;
      env = let
        border =
          if appearance.rounding == 0
          then "sharp"
          else "rounded";
      in {
        FZF_DEFAULT_OPTS = with appearance.colors.withHashtag; ''
          --color=bg+:${base01},bg:${base00},spinner:${base05},hl:${base08}
          --color=fg:${base05},header:${base08},info:${primary},pointer:${base05}
          --color=marker:${base06},fg+:${base05},prompt:${primary},hl+:${base08}
          --color=selected-bg:${base01}
          --color=border:${base02},label:${base05}
          --border="${border}" --preview-window="border-${border}"
        '';
      };
    });
  };
}
