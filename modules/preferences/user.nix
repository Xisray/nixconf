{
  flake.nixosModules.preferences = {
    lib,
    config,
    ...
  }: {
    options.preferences.user = with lib; {
      name = mkOption {
        type = types.str;
        default = "xisray";
      };
    };
    config.users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "input"
      ];
      hashedPasswordFile = "/persist/passwd";
    };
  };
}
