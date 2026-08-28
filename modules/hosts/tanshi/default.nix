{ self, inputs, ... }: {
  flake.nixosConfigurations.tanshi = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.tanshiConfiguration
    ];
  };
}
