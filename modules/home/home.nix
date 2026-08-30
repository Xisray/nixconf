{ self, inputs, ... }: {
  flake.nixosModules.home = { ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      #sharedModules = [
      #  ({ osConfig, ... }: {
      #    home.stateVersion = osConfig.system.stateVersion;
      #  })
      #];
      #users.xisray = self.homeModules.tanshi;
			users.xisray = {
				imports = [
				  #self.homeModules.git
				  self.homeModules.kitty
				];
				programs.home-manager.enable = true;
				home.username = "xisray";
				home.homeDirectory = "/home/xisray";
				home.stateVersion = "26.05";
			};
    };
  };
}
