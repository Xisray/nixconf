{
  flake.wrappers.neovim =
    {
      lib,
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.neovim ];
      settings.config_directory = lib.generators.mkLuaInline "vim.uv.os_homedir() .. '/nixconf/modules/wrappers/neovim'";
      specs.init = {
        data = null;
	      before = [ "MAIN_INIT" ];
      	config = "require('init')";
      };
      specs.extra_rtp = {
        data = null;
        before = [ "MAIN_INIT" ];
        config = ''
          local home = vim.uv.os_homedir()
          vim.opt.rtp:prepend(home .. "/.config/nvim")
          vim.opt.rtp:append(home .. "/.config/nvim/after")
        '';
      };
      specs.plugins = {
        data = [
          pkgs.vimPlugins.lz-n
          pkgs.vimPlugins.base16-nvim
        ];
      };

      languages = {
        nixd = {
          cmd = "nixd";
          packages = pkgs.nixd;
          settings = {
            nixd = {
              nixpkgs.expr = "import <nixpkgs> { }";
              formatting.command = [ (lib.getExe pkgs.alejandra) ];
            };
          };
        };
      };
    };
}
