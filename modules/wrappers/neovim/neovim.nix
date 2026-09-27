{
  flake.wrappers.neovim = {
    lib,
    wlib,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.neovim];
    settings.config_directory = lib.generators.mkLuaInline "vim.uv.os_homedir() .. '/nixconf/modules/wrappers/neovim'";
    settings.compile_generated_lua = false;
    specs.init = {
      data = null;
      before = ["MAIN_INIT"];
      config = "require('init')";
    };
    specs.extra_rtp = {
      data = null;
      before = ["MAIN_INIT"];
      config = ''
        local home = vim.uv.os_homedir()
        vim.opt.rtp:prepend(home .. "/.config/nvim")
        vim.opt.rtp:append(home .. "/.config/nvim/after")
      '';
    };
    plugins = {
      "blink.cmp" = {
        package = pkgs.vimPlugins.blink-cmp;
        lazy = false;
        after.setup = {
          snippets.preset = "luasnip";
          keymap = {
            preset = "enter";
            "<Tab>" = ["select_and_accept" "snippet_forward" "fallback"];
            "<S-Tab>" = ["snippet_backward" "fallback"];
            "<CR>" = ["accept" "fallback"];
          };
        };
      };
      "luasnip".package = pkgs.vimPlugins.luasnip;
      "base16-nvim" = {
        package = pkgs.vimPlugins.base16-nvim;
        after = null;
      };
      "mini.ai".package = pkgs.vimPlugins.mini-ai;
      "mini.icons" = {
        package = pkgs.vimPlugins.mini-icons;
        lazy = false;
        after.extraConfig = "MiniIcons.mock_nvim_web_devicons()";
      };
      "mini.jump".package = pkgs.vimPlugins.mini-jump;
      "mini.pairs".package = pkgs.vimPlugins.mini-pairs;
      "mini.surround".package = pkgs.vimPlugins.mini-surround;
      "mini.indentscope".package = pkgs.vimPlugins.mini-indentscope;
      "oil.nvim" = {
        package = pkgs.vimPlugins.oil-nvim;
        lazy = false;
        after.setup = null;
        after."oil".setup = {
          skip_confirm_for_simple_edits = true;
          float = {
            padding = 2;
            max_width = 0.8;
            max_height = 0.8;
          };
        };
        keys = [
          {
            key = "<leader>e";
            action = ":Oil .<cr>";
            mode = "n";
          }
        ];
      };
    };

    languages = {
      nixd = {
        cmd = "nixd";
        packages = pkgs.nixd;
        settings = {
          nixd = {
            nixpkgs.expr = "import <nixpkgs> { }";
            formatting.command = [(lib.getExe pkgs.alejandra)];
          };
        };
      };
    };
  };
}
