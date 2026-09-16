{
  flake.homeModules.nixvim.programs.nixvim.plugins = {
    mini-ai.enable = true;
    mini-icons = {
      enable = true;
      mockDevIcons = true;
    };
    mini-jump.enable = true;
    mini-pairs.enable = true;
    mini-surround.enable = true;
    mini-indentscope.enable = true;
  };
}
