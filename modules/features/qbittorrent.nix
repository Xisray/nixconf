{
  flake.nixosModules.qbittorrent = { config, ... }: {
    services.qbittorrent = {
      enable = true;
      openFirewall = true;
      serverConfig = {
        Preferences.WebUI.LocalHostAuth = false;
      };
    };
    preferences.persistence.directories = [
      {
        directory = ${config.services.qbittorrent.profileDir};
        user = "qbittorrent";
        group = "qbittorrent";
        mode = "0750";
      }
    ];
  };
}
