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
      specs.plugins = {
        data = [
          pkgs.vimPlugins.lz-n
        ];
      };
    };
}
