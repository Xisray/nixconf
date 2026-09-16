{ inputs, ... }: {
  flake.homeModules.nixvim = {
    imports = [ inputs.nixvim.homeModules.nixvim ];
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };
      opts = {
        number = true;
        relativenumber = true;
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        signcolumn = "yes";
        undofile = true;
        autoread = true;
        laststatus = 3;
        cmdheight = 0;
        textwidth = 120;
        colorcolumn = "120";
      };
    };
    stylix.targets.nixvim.transparentBackground = {
      main = true;
      numberLine = true;
      signColumn = true;
    };
  };
}
