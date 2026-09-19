{
  flake.nixvimModules.oil = {
    programs.nixvim = {
      plugins.oil = {
        enable = true;
        settings = {
          deleteToTrash = true;
          skip_confirm_for_simple_edits = true;
          float = {
            padding = 2;
            max_width = 0.8;
            max_height = 0.8;
          };
        };
      };
      keymaps = [
        {
          mode = "n";
          key = "<leader>e";
          action = ":Oil .<cr>";
          options.silent = true;
        }
      ];
    };
  };
}
