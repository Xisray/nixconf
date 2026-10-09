{
  self,
  lib,
  inputs,
  ...
}: let
  hosts = builtins.attrNames (
    lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./.)
  );
  mkHost = hostname:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit self inputs; };
      modules = [
        {networking.hostName = hostname;}
        ./${hostname}/configuration.nix
        ./${hostname}/hardware.nix
        ./${hostname}/disko.nix
      ];
    };
in {
  config.flake.nixosConfigurations = lib.genAttrs hosts mkHost;
}
