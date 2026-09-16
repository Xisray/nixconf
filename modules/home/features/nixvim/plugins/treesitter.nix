{
  flake.homeModules.nixvim = { pkgs, ... }: {
    programs.nixvim = { config, ... }: {
      plugins.treesitter = {
        enable = true;
        grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
          nix
          lua
          python
          typescript
          tsx
          c_sharp
          c
          cpp
          rust
          json
          yaml
          bash
          markdown
          markdown_inline
          regex
        ];
        highlight.enable = true;
        #indent.enable = true;
      };
    };
  };
}
