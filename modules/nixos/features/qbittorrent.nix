{
  flake.nixosModules.qbittorrent = { ... }: {
    services.qbittorrent = {
      enable = true;
      openFirewall = true;
    };
    users.users.qbittorrent = {
      isSystemUser = true;
      group = "qbittorrent";
    };
    users.groups.qbittorrent = { };
  };
}
