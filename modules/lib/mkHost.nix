{ inputs, ... }: {
  flake.lib.mkHost = name: module: {
    flake.nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        hostName = name;
        inherit inputs;
      };
      modules = [ module ];
    };
  };
}
