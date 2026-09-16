{
  flake.homeModules.nixvim.programs.nixvim.plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native = {
        enable = true;
        settings = {
          fuzzy = true;
          overrideGenericSorter = true;
          overrideFileSorter = true;
          caseMode = "smart_case";
        };
      };

      ui-select = {
        enable = true;
      };

      frecency = {
        enable = true;
        settings = {
          showScores = false;
          showUnindexed = true;
          ignorePatterns = [
            "*.git/*"
            "*/tmp/*"
          ];
        };
      };
    };

    keymaps = {
      "<leader>ff" = {
        action = "find_files";
        options.desc = "Find files";
      };
      "<leader>fg" = {
        action = "live_grep";
        options.desc = "Live grep";
      };
      "<leader>fb" = {
        action = "buffers";
        options.desc = "Buffers";
      };
      "<leader>fr" = {
        action = "frecency";
        options.desc = "Frecency files";
      };
    };
  };
}
