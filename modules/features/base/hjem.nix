{ self, lib, config, ... }: {
  options.flake.hjemExtraModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = { };
    description = "Extra modules for hjem.users.<name>";
  };

  config.flake.nixosModules.hjem =
    { config, lib, ... }:
    let
      username = config.preferences.user.name;
    in
    {
      imports = [
        (lib.mkAliasOptionModule [ "home" ] [ "hjem" "users" username ])
      ];
      home.directory = "/home/${username}";
      hjem.extraModules = lib.attrValues self.hjemExtraModules;
    };
}
