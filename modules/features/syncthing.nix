{ ... }: {
  flake.nixosModules.syncthing = { config, ... }: {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = config.preferences.user.name;
      dataDir = "/home/${config.preferences.user.name}";

      configDir = "/home/${config.preferences.user.name}/.config/syncthing";
    };
    preferences.persistance.data.directories = [
      ".config/syncthing"
      "sync"
    ];
    # networking.firewall.allowedTCPPorts = [ 8384 ];
  };
}
