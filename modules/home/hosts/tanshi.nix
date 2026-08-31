{ self, ... }: {
  flake.homeModules.tanshi = {
    imports = [
      self.homeModules.kitty
      self.homeModules.shell
      self.homeModules.git
      self.homeModules.firefox
    ];
  };
}
