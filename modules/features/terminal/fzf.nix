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
          --color=bg+:${base02},bg:${base00},spinner:${base06},hl:${base08}
          --color=fg:${base05},header:${base08},info:${base0E},pointer:${base06}
          --color=marker:${base07},fg+:${base05},prompt:${base0E},hl+:${base08}
          --color=selected-bg:${base03}
          --color=border:${base04},label:${base05}
          --border="${border}" --preview-window="border-${border}"
        '';
      };
    });
  };
}
