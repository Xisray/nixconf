{
  flake.nixosModules.appearance = {
    config,
    lib,
    ...
  }: let
    cfg = config.appearance;
  in {
    options.appearance.targets.nvim.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    config = lib.mkIf (cfg.hasScheme && cfg.targets.nvim.enable) {
      homefs.files.".config/nvim/lua/theme.lua".text = let
        base16Keys = ["base00" "base01" "base02" "base03" "base04" "base05" "base06" "base07" "base08" "base09" "base0A" "base0B" "base0C" "base0D" "base0E" "base0F"];
        base24Keys = ["base10" "base11" "base12" "base13" "base14" "base15" "base16" "base17"];
        scheme =
          {
            variant = config.appearance.polarity;
          }
          // (lib.genAttrs (base16Keys ++ base24Keys) (name: config.appearance.colors.withHashtag.${name}));
        paletteName = "base24-nix-${lib.substring 0 8 cfg.schemeHash}";
      in ''
        require("tinted-nvim").setup({
          compile = true,
          default_scheme = "${paletteName}",
          schemes = {
            ["${paletteName}"] = ${lib.generators.toLua {} scheme}
          },
        })
      '';
    };
  };
}
