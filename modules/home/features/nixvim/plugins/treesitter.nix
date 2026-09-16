{
  flake.homeModules.nixvim.programs.nixvim.plugins.treesitter = {
    enable = true;
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    highlight.enable = true;
    indent.enable = true;
    folding.enable = true;
  };
}
