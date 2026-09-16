{
  flake.homeModules.nixvim.programs.nixvim = {
    plugins.yazi = {
      enable = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Yazi<cr>";
        options.desc = "Open Yazi";
      }
    ];
  };
}
