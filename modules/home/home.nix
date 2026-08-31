{ self, inputs, ... }: {
  flake.nixosModules.home = { config, hostName, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];
    programs.${config.preferences.shell}.enable = true;
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [
        ({ osConfig, ... }: {
          home = {
            username = config.preferences.user.name;
            homeDirectory = "/home/${config.preferences.user.name}";
            stateVersion = osConfig.system.stateVersion;
          };
        })
      ];
      extraSpecialArgs = {
        nixosConfig = config;
      };
      users.${config.preferences.user.name} = self.homeModules.${hostName};
    };
  };
}
