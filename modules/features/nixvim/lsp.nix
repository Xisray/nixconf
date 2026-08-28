{ self, inputs, ... }: {
  flake.nixosModules.nixvim = { pkgs, lib, ... }: {
    programs.nixvim = {
      lsp = {
        servers = {
          nixd = {
            enable = true;
            config = {
              cmd = [ "${lib.getExe pkgs.nixd}" ];
              filetypes = [ "nix" ];
            };
          };
        };
      };
      autoCmd = [
        {
          event = "LspAttach";
          callback.__raw = ''
            function(ev)
              local client = vim.lsp.get_client_by_id(ev.data.client_id)
              if client ~= nil and client:supports_method("textDocument/completion") then
                vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
              end
            end
          '';
        }
      ];
      diagnostic.settings.virtual_text = true;
    };
  };
}
