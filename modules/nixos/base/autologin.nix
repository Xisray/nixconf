{
  flake.nixosModules.autologin = { config, ... }: {
    services.getty = {
      autologinUser = config.preferences.user.name;
      # autologinOnce = true;
    };
  };
}
