{ self, inputs, ... }: {
  flake.nixosModules.home =
    { config, hostName, ... }:
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
        extraSpecialArgs = {
          nixosConfig = config;
        };
        users.${user} = self.homeModules.${hostName};
      };
    };
}
