{ self, inputs, ... }: {
  flake.nixosModules.starship = { pkgs, lib, ... }: {

  };

  perSystem = { pkgs, ... }: {
    packages.starship = inputs.wrapper-modules.wrappers.starship.wrap {
      inherit pkgs;
    };
  };
}
