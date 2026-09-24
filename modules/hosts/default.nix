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
      specialArgs = {
        inherit inputs hostname;
        wlib = inputs.wrappers.lib;
      };
      modules = [
        { networking.hostName = hostname; }
        inputs.disko.nixosModules.disko
        inputs.hjem.nixosModules.default

        self.nixosModules."${hostname}Configuration"
        self.nixosModules."${hostname}Hardware"
        self.diskoConfigurations.${hostname}

        self.nixosModules.impermanence
        self.nixosModules.nix
        self.nixosModules.boot
        self.nixosModules.audio
        self.nixosModules.fonts
        self.nixosModules.preferences
        self.nixosModules.hjem
        self.nixosModules.shell
        self.nixosModules.general
      ];
    };
in
{
  options.hosts = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Список зарегистрированных хостов";
  };

  config.flake.nixosConfigurations = lib.genAttrs config.hosts mkHost;
}
