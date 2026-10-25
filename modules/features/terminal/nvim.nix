{self, ...}: {
  flake.nixosModules.nvim = {
    config,
    lib,
    pkgs,
    ...
  }: let
    base16Keys = [
      "base00"
      "base01"
      "base02"
      "base03"
      "base04"
      "base05"
      "base06"
      "base07"
      "base08"
      "base09"
      "base0A"
      "base0B"
      "base0C"
      "base0D"
      "base0E"
      "base0F"
    ];
    base24Keys = [
      "base10"
      "base11"
      "base12"
      "base13"
      "base14"
      "base15"
      "base16"
      "base17"
    ];
    scheme =
      if config.appearance.scheme == null
      then null
      else
        {
          variant = config.appearance.polarity;
        }
        // (lib.genAttrs (base16Keys ++ base24Keys) (name: config.appearance.colors.withHashtag.${name}));
    hasScheme = scheme != null;
    neovim = self.wrappers.neovim or null;
    hash = builtins.substring 0 8 (builtins.hashString "sha256" (builtins.toJSON scheme));
  in {
    homefs.files.".config/nvim/lua/theme.lua".text = lib.mkIf hasScheme ''
      require("tinted-nvim").setup({
        compile = true,
        default_scheme = "base24-nix-${hash}",
        schemes = {
          ["base24-nix-${hash}"] = ${lib.generators.toLua {} scheme}
        },
      })
    '';
    shell.packages.neovim = lib.mkIf (neovim != null && hasScheme) (
      neovim.wrap {
        inherit pkgs;
        mode = "dynamic";
        plugins = lib.mkIf hasScheme {
          "tinted-nvim" = {
            package = pkgs.vimPlugins.tinted-nvim;
            after.setup = null;
          };
        };
        specs.extra_rtp = lib.mkIf hasScheme {
          data = null;
          before = ["MAIN_INIT"];
          config = ''
            local home = vim.uv.os_homedir()
            vim.opt.rtp:prepend(home .. "/.config/nvim")
            vim.opt.rtp:append(home .. "/.config/nvim/after")
            pcall(require, 'theme')
          '';
        };
      }
    );
  };
}
