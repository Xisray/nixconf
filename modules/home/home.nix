{ self, inputs, ... }: {
  flake.nixosModules.home =
    { config, ... }:
    let
      user = config.preferences.user.name;
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      programs.${config.preferences.shell}.enable = true;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [
          self.sharedModules.preferences
          ({ osConfig, ... }: {
            home = {
              username = config.preferences.user.name;
              homeDirectory = "/home/${user}";
              stateVersion = osConfig.system.stateVersion;
            };
          })
        ];
        users.${user} = self.homeModules.home;
      };
    };
  flake.homeModules.home = {
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
