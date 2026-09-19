{ inputs, lib, ... }: {
  options.flake = {
    nixvimModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
    };
  };
  config = {
    flake.homeModules.nixvim = {
      imports = [ inputs.nixvim.homeModules.nixvim ];
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        clipboard = {
          register = "unnamedplus";
          providers.wl-copy.enable = true;
        };
        opts = {
          number = true;
          relativenumber = true;
          tabstop = 2;
          softtabstop = 2;
          shiftwidth = 2;
          autoindent = true;
          smartindent = true;
          expandtab = true;
          signcolumn = "yes";
          undofile = true;
          autoread = true;
          laststatus = 3;
          cmdheight = 0;
        };

        highlightOverride = {
          NormalFloat.bg = "NONE";
          FloatBorder.bg = "NONE";
          CursorLineSign.bg = "NONE";
          DiagnosticSignError.link = "DiagnosticError";
          DiagnosticSignWarn.link = "DiagnosticWarn";
          DiagnosticSignInfo.link = "DiagnosticInfo";
          DiagnosticSignHint.link = "DiagnosticHint";
        };
      };
      stylix.targets.nixvim.transparentBackground = {
        main = true;
        numberLine = true;
        signColumn = true;
      };
    };
  };
}
