{
  flake.wrappers.neovim = {
    pkgs,
    lib,
    config,
    ...
  }: let
    typeOrListOfType = type: lib.types.either type (lib.types.listOf type);
    rootMarkersType = lib.types.either lib.types.str (
      lib.types.listOf (typeOrListOfType lib.types.str)
    );

    languageType = lib.types.submodule {
      freeformType = lib.types.attrsOf lib.types.anything;
      options = {
        lsp = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        cmd = lib.mkOption {
          type = typeOrListOfType lib.types.str;
          default = [];
        };
        packages = lib.mkOption {
          type = typeOrListOfType lib.types.package;
          default = [];
        };
        filetypes = lib.mkOption {
          type = typeOrListOfType lib.types.str;
          default = [];
        };
        root_markers = lib.mkOption {
          type = rootMarkersType;
          default = [];
        };
        extra_config = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
        formatters = lib.mkOption {
          type = typeOrListOfType lib.types.str;
          default = [];
        };
        formatter_filetypes = lib.mkOption {
          type = typeOrListOfType lib.types.str;
          default = [];
        };
        treesitter = lib.mkOption {
          type = typeOrListOfType lib.types.str;
          default = [];
        };
      };
    };

    metaKeys = [
      "lsp"
      "packages"
      "extra_config"
      "formatters"
      "formatter_filetypes"
      "treesitter"
    ];

    mkLspConfig = name: lang: let
      raw = removeAttrs lang metaKeys;
      normalized =
        raw
        // {
          cmd = lib.toList raw.cmd;
          filetypes = lib.toList raw.filetypes;
          root_markers = lib.toList raw.root_markers;
        };
      nonEmpty = lib.filterAttrs (_: v: v != [] && v != null) normalized;
    in
      lib.optionalString lang.lsp ''
        ${
          lib.optionalString (nonEmpty != {}) ''
            vim.lsp.config["${name}"] = ${lib.generators.toLua {} nonEmpty}
          ''
        }${lib.optionalString (lang.extra_config != null) "${lang.extra_config}\n"}vim.lsp.enable("${name}")
      '';
  in {
    options = {
      languages = lib.mkOption {
        type = lib.types.attrsOf languageType;
        default = {};
      };
      formatOnSave = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };

    config = let
      cfg = config.languages;
      langs = lib.attrValues cfg;

      lspConfigs = lib.mapAttrsToList mkLspConfig cfg;

      formattersByFt =
        lib.foldl' (
          acc: lang: let
            fmts = lib.toList lang.formatters;
            fts = lib.toList (
              if lang.formatter_filetypes != []
              then lang.formatter_filetypes
              else lang.filetypes
            );
          in
            if fmts == [] || fts == []
            then acc
            else acc // lib.genAttrs fts (_: fmts)
        ) {}
        langs;

      grammars = lib.unique (lib.concatMap (l: lib.toList l.treesitter) langs);

      conformOpts =
        {
          formatters_by_ft = formattersByFt;
          default_format_opts.lsp_format = "fallback";
        }
        // lib.optionalAttrs config.formatOnSave {
          format_on_save = {
            timeout_ms = 1000;
            lsp_format = "fallback";
          };
        };
    in {
      runtimePkgs = lib.flatten (map (l: lib.toList l.packages) langs);

      specs.languages = {
        data = null;
        config = lib.concatStringsSep "\n" lspConfigs;
      };

      plugins = {
        "nvim-lspconfig" = {
          package = pkgs.vimPlugins.nvim-lspconfig;
          lazy = false;
          after = null;
          before.extraConfig = ''
            local on_attach = function(client, bufnr)
              local opts = { noremap = true, silent = true, buffer = bufnr }

              vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, opts)
              vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
              vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
            end

            local ok, blink = pcall(require, "blink.cmp")
            local capabilities = ok
              and blink.get_lsp_capabilities()
              or vim.lsp.protocol.make_client_capabilities()

            vim.lsp.config('*', {
              capabilities = capabilities,
              on_attach = on_attach,
            })
          '';
        };

        "conform.nvim" = {
          package = pkgs.vimPlugins.conform-nvim;
          lazy = false;
          after = {
            setup = null;
            "conform".setup = conformOpts;
            extraConfig = ''
              local function fmt()
                require("conform").format({ async = true, lsp_format = "fallback" })
              end
              vim.keymap.set({ "n", "v" }, "<leader>F", fmt, { desc = "Format buffer/range" })
              vim.keymap.set("v", "F", fmt, { desc = "Format range" })
            '';
          };
        };

        "nvim-treesitter" = {
          package = pkgs.vimPlugins.nvim-treesitter.withPlugins (
            p: map (name: p.${name}) grammars
          );
          lazy = false;
          after = null;
          before.extraConfig = ''
            vim.api.nvim_create_autocmd("FileType", {
              callback = function(args)
                if pcall(vim.treesitter.start, args.buf) then
                  vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
              end,
            })
          '';
        };
      };
    };
  };
}
