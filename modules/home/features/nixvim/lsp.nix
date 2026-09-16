{
  flake.homeModules.nixvim = { pkgs, lib, ... }: {
    programs.nixvim = {
      lsp = {
        servers = {
          nixd.enable = true;
          # package = pkgs.nixd;
          # config = {
          #   cmd = [ "${lib.getExe pkgs.nixd}" ];
          #   filetypes = [ "nix" ];
          # };
          lua_ls.enable = true;
          pyright.enable = true;
          ts_ls.enable = true;
          csharp_ls.enable = true;
          clangd.enable = true;
          rust_analyzer.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
          bashls.enable = true;
          dockerls.enable = true;
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
