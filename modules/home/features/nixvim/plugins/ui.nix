{
  flake.nixvimModules.ui = {
    programs.nixvim.plugins = {
      lualine.enable = true;
      modicator.enable = true;
    };
  };
}
