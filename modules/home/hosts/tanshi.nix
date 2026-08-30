{ self, ... }: {
  flake.homeModules.tanshi = {
    imports = [
      self.homeModules.kitty
      self.homeModules.fish
      self.homeModules.git
    ];
  };
}
