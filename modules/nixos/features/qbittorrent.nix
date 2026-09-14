{
  flake.nixosModules.qbittorrent = {
    services.qbittorrent = {
      enable = true;
      openFirewall = true;
      serverConfig = {
        Preferences.WebUI.LocalHostAuth = true;
      };
    };
    users.users.qbittorrent = {
      isSystemUser = true;
      group = "qbittorrent";
    };
    users.groups.qbittorrent = { };
    preferences.persistance.directories = [
      "/var/lib/qBittorrent/qBittorrent"
    ];
  };
}
