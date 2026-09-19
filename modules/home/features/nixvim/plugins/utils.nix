{
  flake.nixvimModules.utils = { pkgs, ... }: {
    programs.nixvim = {
      plugins = {
        schemastore.enable = true;
        luasnip.enable = true;
        blink-cmp = {
          enable = true;
          settings = {
            keymap = {
              preset = "enter";
              "<Tab>" = [
                "select_and_accept"
                "snippet_forward"
                "fallback"
              ];
              "<S-Tab>" = [
                "snippet_backward"
                "fallback"
              ];
              "<CR>" = [
                "accept"
                "fallback"
              ];
            };
            completion.list.selection.preselect = false;
          };
        };
        blink-ripgrep.enable = true;
        tiny-inline-diagnostic = {
          enable = true;
          settings = {
            options = {
              multilines = {
                enabled = true;
                #always_show = true;
              };
            };
            preset = "classic";
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
