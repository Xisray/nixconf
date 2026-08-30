{ self, inputs, ... }: {
  flake.nixosModules.home = { config, hostName, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [
        ({ osConfig, ... }: {
          home.stateVersion = osConfig.system.stateVersion;
        })
      ];
      users.${config.preferences.user.name} = self.homeModules.${hostName};
    };
  };
}
