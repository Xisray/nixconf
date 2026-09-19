{
  flake.homeModules.nixvim = {
    programs.nixvim = {
      plugins.lspconfig.enable = true;
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
      opts = {
        completeopt = [
          "menu"
          "menuone"
          "noselect"
        ];
      };
    };
  };
}
