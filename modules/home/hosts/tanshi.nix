{ self, ... }: {
  flake.homeModules.tanshi = {
    imports = [
      self.homeModules.kitty
    ];
  };
}
