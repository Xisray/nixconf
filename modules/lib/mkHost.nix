{ self, inputs, ... }: {
  flake.lib.mkHost = name: {
    flake.nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        hostName = name;
        inherit self inputs;
      };
      modules = [ self.nixosModules."${name}Configuration" ];
    };
  };
}
