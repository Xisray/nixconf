{ self, ... }: {
  flake.nixosModules.shell =
    { config, pkgs, ... }:
    let
      user = config.preferences.user;
    in
    {
      users.users.${user.name}.shell = config.programs.${user.shell}.package;
      programs.${user.shell} = {
        enable = true;
        package = self.package.${pkgs.stdenv.hostPlatform.system}.${user.shell};
      };
      programs.zoxide = {
        enable = true;
        flags = [ "--cmd cd" ];
      };
    };
}
