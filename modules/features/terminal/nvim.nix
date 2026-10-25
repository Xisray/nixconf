{self, ...}: {
  flake.nixosModules.nvim = {
    config,
    lib,
    pkgs,
    ...
  }: let
    neovim = self.wrappers.neovim or null;
  in {
    shell.packages.neovim = lib.mkIf (neovim != null && config.appearance.hasScheme) (
      neovim.wrap {
        inherit pkgs;
        mode = "dynamic";
        plugins = {
          "tinted-nvim" = {
            package = pkgs.vimPlugins.tinted-nvim;
            after.setup = null;
          };
        };
        specs.extra_rtp = {
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
