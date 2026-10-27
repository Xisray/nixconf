{inputs, ...}: let
  mkPkgsUnfree = system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
in {
  flake.nixosModules.unfree = {pkgs, ...}: {
    _module.args.pkgsUnfree = mkPkgsUnfree pkgs.stdenv.hostPlatform.system;
  };

  perSystem = {system, ...}: {
    _module.args.pkgsUnfree = mkPkgsUnfree system;
  };
}
