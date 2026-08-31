{ self, inputs, ... }: {
  flake.homeModules.nixvim = { pkgs, lib, ... }: {
    imports = [ inputs.nixvim.homeModules.nixvim ];
    programs.nixvim = {
      enable = true;
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
        signcolumn = "yes";
        undofile = true;
        autoread = true;
        laststatus = 3;
        cmdheight = 0;
      };
    };
  };
}
