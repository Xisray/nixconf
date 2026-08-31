{ self, inputs, ... }: {
  flake.homeModules.nixvim = { pkgs, lib, ... }: {
    programs.nixvim = {
      globals = {
        netrw_liststyle = 3;
        netrw_banner = 0;
        netrw_winsize = 25;
        netrw_browse_split = 0;
        netrw_altfile = 1;
      };
      keymaps = [
        {
          mode = "n";
          key = "<leader>e";
          action = ":Lexplore<cr>";
          options.silent = true;
        }
      ];
      autoCmd = [
        {
          event = [ "FileType" ];
          pattern = "netrw";
          callback.__raw = ''
            function()
            		vim.keymap.set("n", "%", function()
            			local fname = vim.fn.input("Enter filename: ")
            			if fname == "" then
            				return
            			end

            			local dir = vim.b.netrw_curdir or vim.fn.getcwd()
            			local path = dir .. "/" .. fname

            			if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
            				vim.notify("Already exists: " .. fname, vim.log.levels.WARN)
            				return
            			end

            			if fname:match("/$") then
            				vim.fn.mkdir(path, "p")
            				vim.cmd("edit")
            			else
            				local f = io.open(path, "w")
            				if not f then
            					vim.notify("Failed to create: " .. fname, vim.log.levels.ERROR)
            					return
            				end
            				f:close()

            				local escaped = vim.fn.fnameescape(path)
            				if vim.fn.winnr("#") == 0 then
            					vim.cmd("edit " .. escaped)
            				else
            					vim.cmd("wincmd p")
            					vim.cmd("edit " .. escaped)
            				end
            			end
            		end, { buffer = true, silent = true, noremap = true, desc = "Create file in previous window" })
            	end
          '';
        }
      ];
    };
  };
}
