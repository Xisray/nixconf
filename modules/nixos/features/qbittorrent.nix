{
  flake.nixosModules.qbittorrent = {
    services.qbittorrent = {
      enable = true;
      openFirewall = true;
      serverConfig = {
        Preferences.WebUI.LocalHostAuth = false;
      };
    };
    users.users.qbittorrent = {
      isSystemUser = true;
      group = "qbittorrent";
    };
    users.groups.qbittorrent = { };
    preferences.persistance.directories = [
      {
        directory = "/var/lib/qBittorrent/qBittorrent";
        user = "qbittorrent";
        group = "qbittorrent";
        mode = "0750";
      }
    ];
  };
}
