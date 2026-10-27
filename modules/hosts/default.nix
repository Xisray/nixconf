{
  self,
  lib,
  inputs,
  ...
}: let
  hosts = builtins.attrNames (lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./.));
  mkHost = hostname:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self inputs;
        wlib = inputs.wrappers.lib;
      };
      modules = [
        {networking.hostName = hostname;}
        inputs.disko.nixosModules.disko
        self.nixosModules.${hostname}
        self.diskoConfigurations.${hostname}
      ];
    };
in {
  flake.nixosConfigurations = lib.genAttrs hosts mkHost;
  flake.nixosModules = lib.genAttrs hosts (hostname: {
    imports = [
      ./${hostname}/_configuration.nix
      ./${hostname}/_hardware.nix
    ];
  });
  flake.diskoConfigurations = lib.genAttrs hosts (hostname: {
    imports = [
      ./${hostname}/_disko.nix
    ];
  });
}
