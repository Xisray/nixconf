{
  self,
  lib,
  inputs,
  config,
  ...
}:
let
  mkHost =
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs hostname; };
      modules = [
        { networking.hostName = hostname; }
        inputs.disko.nixosModules.disko
        inputs.wrappers.flakeModules.wrappers
        self.nixosModules."${hostname}Configuration"
        self.nixosModules."${hostname}Hardware"
        self.diskoConfigurations.${hostname}
        inputs.hjem.nixosModules.default
        self.nixosModules.general
      ];
    };
in
{
  options = {
    hosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Список зарегистрированных хостов";
    };
  };

  config = {
    flake.nixosConfigurations = lib.genAttrs config.hosts mkHost;
  };
}
