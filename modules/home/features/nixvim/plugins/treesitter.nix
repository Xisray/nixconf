{
  flake.nixvimModules.treesitter = {
    programs.nixvim.plugins.treesitter = {
      enable = true;
      highlight.enable = true;
    };
  };
}
