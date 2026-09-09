{ self, ... }: {
  flake.homeModules.tanshi = {
    imports = [
      self.homeModules.general
      self.homeModules.kitty
      self.homeModules.shell
      self.homeModules.starship
      self.homeModules.git
      self.homeModules.firefox
      self.homeModules.nixvim
      self.homeModules.keepassxc
      self.homeModules.noctalia
    ];
  };
}
