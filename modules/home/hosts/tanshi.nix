{ self, ... }: {
  flake.homeModules.tanshi = {
		imports = [
		  #self.homeModules.git
		  self.homeModules.kitty
		];
	};
}
