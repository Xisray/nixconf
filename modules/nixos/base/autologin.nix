{
  flake.nixosModules.autologin = { config, ... }: {
    services.greetd = {
      enable = true;
      settings.default_session = {
        user = config.preferences.user.name;
      };
    };
  };
}
