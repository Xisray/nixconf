{ self, ... }: {
  flake.homeModules.nixvim = {
    imports = [
      self.nixvimModules.mini
      self.nixvimModules.telescope
      self.nixvimModules.treesitter
      self.nixvimModules.ui
      self.nixvimModules.utils
      self.nixvimModules.oil
    ];
  };
}
