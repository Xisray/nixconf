{
  flake.homeModules.nixvim =
    { pkgs, lib, ... }:
    let
      languages = {
        nix = {
          lsp = "nixd";
          formatter = "nixfmt";
          grammar = "nix";
          formatterPkg = pkgs.nixfmt;
        };
        lua = {
          lsp = "lua_ls";
          formatter = "stylua";
          grammar = "lua";
          formatterPkg = pkgs.stylua;
        };
        python = {
          lsp = "pyright";
          formatter = "ruff_format";
          grammar = "python";
          formatterPkg = pkgs.ruff;
        };
        typescript = {
          lsp = "ts_ls";
          formatter = "prettier";
          grammar = [
            "typescript"
            "tsx"
          ];
          formatterPkg = pkgs.prettier;
        };
        c_sharp = {
          lsp = "csharp_ls";
          grammar = "c_sharp";
        };
        c = {
          lsp = "clangd";
          grammar = [
            "c"
            "cpp"
          ];
        };
        rust = {
          lsp = "rust_analyzer";
          grammar = "rust";
        };
        json = {
          lsp = "jsonls";
          formatter = "jq";
          grammar = "json";
          formatterPkg = pkgs.jq;
        };
        yaml = {
          lsp = "yamlls";
          grammar = "yaml";
        };
        bash = {
          lsp = "bashls";
          grammar = "bash";
        };
        docker = {
          lsp = "dockerls";
        };
        typst = {
          lsp = "tinymist";
          formatter = "typstyle";
          formatterPkg = pkgs.typstyle;
        };
      };

      enabledLsps = lib.filterAttrs (_: v: v ? lsp && v.lsp != null) languages;
      withFormatter = lib.filterAttrs (_: v: v ? formatter && v.formatter != null) languages;

      grammarNames = lib.unique (
        lib.flatten (
          lib.mapAttrsToList (
            _: v:
            if !(v ? grammar) || v.grammar == null then
              [ ]
            else if builtins.isList v.grammar then
              v.grammar
            else
              [ v.grammar ]
          ) languages
        )
        ++ [
          "markdown"
          "markdown_inline"
          "regex"
        ]
      );
    in
    {
      programs.nixvim = { config, ... }: {
        lsp.servers = lib.mapAttrs' (_: v: {
          name = v.lsp;
          value = {
            enable = true;
          };
        }) enabledLsps;
        plugins = {
          lspconfig.enable = true;
          conform-nvim.settings = {
            formatters_by_ft = lib.mapAttrs (_: v: [ v.formatter ]) withFormatter;
            formatters = lib.mapAttrs' (_: v: {
              name = v.formatter;
              value = lib.optionalAttrs (v ? formatterPkg) {
                command = lib.getExe v.formatterPkg;
              };
            }) (lib.filterAttrs (_: v: v ? formatterPkg) withFormatter);
          };
          treesitter.grammarPackages = map (
            g: config.plugins.treesitter.package.builtGrammars.${g}
          ) grammarNames;
        };
      };
    };
}
