{self, ...}: {
  flake.shellModules.neovim = {
    lib,
    appearance,
    ...
  }: let
    neovim = self.wrappers.neovim or null;
  in {
    packages.neovim = lib.mkIf (neovim != null && appearance.scheme != null) neovim.wrap {
      colorscheme = {
        colors = appearance.colors.withHashtag;
        base24 = appearance.base24;
      };
    };
  };
}
