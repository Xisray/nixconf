{ self, ... }: {
  flake.homeModules.nixos = {
    imports = [
      self.homeModules.general
      self.homeModules.kitty
      self.homeModules.shell
      self.homeModules.starship
      self.homeModules.ssh
      self.homeModules.git
      self.homeModules.firefox
      self.homeModules.nixvim
      self.homeModules.keepassxc
      self.homeModules.noctalia
      self.homeModules.voxtype
      self.homeModules.cliamp
    ];
  };
}
