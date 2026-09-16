{
  flake.homeModules.nixvim.programs.nixvim = {
    plugins.yazi = {
      enable = true;
      settings = {
      };
    };
    #keymaps = [
    #  {
    #    mode = "n";
    #    key = "<leader>e";
    #    action = ":Oil .<cr>";
    #    options.silent = true;
    #  }
    #];
  };
}
