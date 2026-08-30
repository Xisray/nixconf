{ self, inputs, ... }: {
  flake.nixosModules.home = { config, hostName, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.preferences.user.name} = self.homeModules.${hostName};
    };

  };
}
