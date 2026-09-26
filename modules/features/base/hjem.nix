{ self, ... }: {
  flake.nixosModules.hjem =
    { config, lib, ... }:
    let
      username = config.preferences.user.name;
    in
    {
      imports = [
        (lib.mkAliasOptionModule [ "home" ] [ "hjem" "users" username ])
      ];
      home.directory = "/home/${username}";
      hjem.extraModules = [ self.hjemExtraModules.xdgDesktopEntries ];
    };
}
