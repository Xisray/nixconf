{
  flake.wrappers.neovim = {
    pkgs,
    lib,
    config,
    ...
  }: let
    typeOrListOfType = type: lib.types.either type (lib.types.listOf type);
    rootMarkersType = lib.types.either lib.types.str (lib.types.listOf (typeOrListOfType lib.types.str));

    languageType = lib.types.submodule {
      freeformType = lib.types.attrsOf lib.types.anything;
      options = {
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
      };
    };

    metaKeys = ["packages" "extra_config"];
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
    in ''
      ${lib.optionalString (nonEmpty != {}) ''
        vim.lsp.config["${name}"] = ${lib.generators.toLua {} nonEmpty}
      ''}${lib.optionalString (lang.extra_config != null) "${lang.extra_config}\n"}vim.lsp.enable("${name}")
    '';
  in {
    options.languages = lib.mkOption {
      type = lib.types.attrsOf languageType;
      default = {};
    };
    config = let
      cfg = config.languages;
      lspConfigs = lib.mapAttrsToList mkLspConfig cfg;
    in {
      runtimePkgs = lib.flatten (lib.mapAttrsToList (_: lang: lib.toList lang.packages) cfg);
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

              vim.keymap.set('v', 'F', vim.lsp.buf.format, opts)
              vim.keymap.set('n', '<leader>F', vim.lsp.buf.format, opts)
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
      };
    };
  };
}
