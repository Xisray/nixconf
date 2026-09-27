{ self, ... }: {
  flake.nixosModules.cliamp = { pkgs, ... }: {
    home.packages = [
      (self.packages.${pkgs.stdenv.hostPlatform.system}.cliamp or pkgs.cliamp)
    ];
  };
}
