{
  flake.nixosModules.preferences = {
    lib,
    config,
    ...
  }: {
    imports = [(lib.mkAliasOptionModule ["user"] ["users" "users" config.preferences.user.name])];
    options.preferences.user = with lib; {
      name = mkOption {
        type = types.str;
        default = "xisray";
      };
      packages = mkOption {
        type = types.listOf types.package;
        default = [];
      };
      shell = lib.mkOption {
        type = lib.types.enum ["fish"];
        default = "fish";
      };
    };
    config = {
      user = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "input"
        ];
        hashedPasswordFile = "/persist/passwd";
        packages = config.preferences.user.packages;
      };
    };
  };
}
