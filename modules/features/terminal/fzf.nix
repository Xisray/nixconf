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
          --color=bg+:${base01},bg:${base00},spinner:${base0C},hl:${base0D}
          --color=fg:${base05},header:${base0D},info:${base0A},pointer:${base0C}
          --color=marker:${base0C},fg+:${base06},prompt:${base0A},hl+:${base0D}
          --color=selected-bg:${base03}
          --color=border:${base04},label:${base05}
          --border="${border}" --preview-window="border-${border}"
        '';
      };
    });
  };
}
