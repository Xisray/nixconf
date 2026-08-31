{ self, inputs, ... }: {
  flake.homeModules.nixvim = { pkgs, lib, ... }: {
    programs.nixvim = {
      autoGroups.highlight_yank.clear = true;
      autoCmd = [
        {
          event = "TextYankPost";
          pattern = "*";
          group = "highlight_yank";
          desc = "Highlight selection on yank";
          callback.__raw = ''
            function()
              vim.highlight.on_yank({ timeout = 200, visual = true })
            end
          '';
        }
        {
          event = "BufReadPost";
          callback.__raw = ''
            function(args)
              local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
              local line_count = vim.api.nvim_buf_line_count(args.buf)
              if mark[1] > 0 and mark[1] <= line_count then
                vim.api.nvim_win_set_cursor(0, mark)
                -- defer centering slightly so it's applied after render
                vim.schedule(function()
                  vim.cmd("normal! zz")
                end)
              end
            end
          '';
        }
      ];
    };
  };
}
