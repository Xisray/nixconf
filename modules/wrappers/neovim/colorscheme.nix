{
  flake.wrappers.neovim = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.colorscheme = {
      colors = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
      };
      base24 = lib.mkEnableOption "Use base24";
    };
    config = let
      cfg = config.colorscheme;
      base16Keys = ["base00" "base01" "base02" "base03" "base04" "base05" "base06" "base07" "base08" "base09" "base0A" "base0B" "base0C" "base0D" "base0E" "base0F"];
      base24Keys = ["base10" "base11" "base12" "base13" "base14" "base15" "base16" "base17"];
      variant =
        if cfg.base24
        then "base24"
        else "base16";
      keys = base16Keys ++ lib.optionals cfg.base24 base24Keys;
      palette = lib.getAttrs keys cfg.colors;
      scheme = {variant = "";} // palette;
    in {
      specs.colorscheme = lib.mkIf (cfg.colors != {}) {
        data = [pkgs.vimPlugins.tinted-nvim];
        config = ''
          require("tinted-nvim").setup({
            compile = true,
            default_scheme = "${variant}-theme",
            schemes = {
              ["${variant}-theme"] = ${lib.generators.toLua {} scheme},
            },
          })
        '';
      };
      plugins = lib.mkIf (cfg.colors != {}) {
        "lualine.nvim".after."lualine".setup.options.theme = "tinted";
      };
    };
  };
}
