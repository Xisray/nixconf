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
          home = {
					  username = config.preferences.user.name;
						homeDirectory = "/home/${config.preferences.user.name}";
					  stateVersion = osConfig.system.stateVersion;
					};
        })
      ];
      users.${config.preferences.user.name} = self.homeModules.${hostName};
    };
  };
}
