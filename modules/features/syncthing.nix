{
  flake.nixosModules.syncthing = { config, ... }: {
    services.syncthing =
    let
      username = config.preferences.user.name;
    in {
      enable = true;
      openDefaultPorts = true;
      user = username;
      dataDir = "/home/${username}/sync";
      configDir = "/home/${username}/.config/syncthing";
    };
    preferences.persistence.data.directories = [
      ".config/syncthing"
      "sync"
    ];
  };
}
