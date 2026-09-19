{
  flake.nixvimModules.utils = { pkgs, ... }: {
    programs.nixvim = {
      plugins = {
        schemastore.enable = true;
        luasnip.enable = true;
        blink-cmp.enable = true;
        blink-ripgrep.enable = true;
        tiny-inline-diagnostic = {
          enable = true;
          settings = {
            multilines = {
              enabled = true;
            };
            options = {
              use_icons_from_diagnostic = true;
            };
            preset = "classic";
            virt_texts = {
              priority = 2048;
            };
          };
        };
        fidget.enable = true;
      };

      extraPlugins = with pkgs.vimPlugins; [
        tiny-cmdline-nvim
      ];
      extraConfigLua = ''
        require("vim._core.ui2").enable({})
        require("tiny-cmdline").setup({
          on_reposition = require("tiny-cmdline").adapters.blink,
        })
        vim.api.nvim_set_hl(0, "TinyCmdlineBorder", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "TinyCmdlineNormal", { bg = "NONE" })
      '';
    };
  };
}
