{ self, inputs, ... }: {
  flake.nixosModules.nixvim = { pkgs, lib, ... }: {
    programs.nixvim = {
      globals = {
        mapleader = " ";
      };
      keymaps = [
        {
          mode = "n";
          key = "U";
          action = "<c-r>";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<leader>w";
          action = ":w<cr>";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<leader>q";
          action = ":q<cr>";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<leader>f";
          action = ":find ";
          options.silent = false;
        }
        {
          mode = "n";
          key = "<leader>d";
          action.__raw = ''
            function()
              vim.diagnostic.setqflist()
            	vim.cmd("copen")
            end
          '';
          options.silent = true;
        }
      ];
    };
  };
}
