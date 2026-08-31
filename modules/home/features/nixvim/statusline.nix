{ self, inputs, ... }: {
  flake.homeModules.nixvim = { pkgs, lib, ... }: {
    programs.nixvim = {
      opts.statusline = "%!v:lua._statusline()";
      autoCmd = [
        {
          event = [ "BufEnter" ];
          callback.__raw = ''
            function()
              local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
              if root ~= "" then
                vim.b.git_branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+$", "")
                vim.b.rel_path = vim.fn.expand("%:p"):sub(#root + 2)
              else
                vim.b.git_branch = nil
                vim.b.rel_path = vim.fn.expand("%:p:~")
              end
            end
            					'';
        }
        {
          event = [ "DiagnosticChanged" ];
          callback.__raw = ''
            function()
              vim.cmd("redrawstatus!")
            end
            					'';
        }
      ];

      extraConfigLua = ''
                local function setup_statusline_highlights()
        				  local bg = "${self.theme.base01}"
        					local mode_bg = "${self.theme.base02}"
        					local mode_fg = "${self.theme.base07}"
        					local git_fg = "${self.theme.base0D}"
        					local fg = "${self.theme.base05}"
                  vim.api.nvim_set_hl(0, "StlMode", { fg = mode_fg, bg = mode_bg, bold = true })
                  vim.api.nvim_set_hl(0, "StlGit", { fg = git_fg, bg = bg })
                  vim.api.nvim_set_hl(0, "StausLine", { fg = fg, bg = bg })
                  vim.api.nvim_set_hl(0, "StausLineNC", { fg = "${self.theme.base03}", bg = bg })
                end

                setup_statusline_highlights()

                vim.api.nvim_create_autocmd("ColorScheme", {
                  callback = setup_statusline_highlights,
                })
                        
                local modes = {
                  n = "NORMAL",
                  i = "INSERT",
                  v = "VISUAL",
                  V = "V-LINE",
                  ["\22"] = "V-BLOCK",
                  c = "COMMAND",
                  t = "TERMINAL",
                	R = "REPLACE",
                	s = "SELECT",
                	S = "S-LINE",
                	["\19"] = "S-BLOCK",
                }
                        
                function _G._statusline()
                  local mode = modes[vim.fn.mode()] or vim.fn.mode():upper()
                	local branch = vim.b.git_branch and "%#StlGit# " .. vim.b.git_branch .. " %*" or ""
                	local path = vim.b.rel_path or "%f"
                	local diag = ""
                	local counts = vim.diagnostic.count(0) or {}
                	local labels = { " ", " ", " ", " " }
                	local hls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
                	for i = 1, 4 do
                	  if counts[i] and counts[i] > 0 then
                		  diag = diag .. "%#" .. hls[i] .. "#" .. labels[i] .. counts[i] .. "%* "
                    end
                  end
                	return "%#StlMode# " .. mode .. " %*" .. branch .. " " .. path .. "%=" .. diag .. vim.bo.filetype .. " %l:%c"
                end
                			'';
    };
  };
}
