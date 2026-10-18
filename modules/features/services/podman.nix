{
  flake.nixosModules.podman = {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    preferences.persistence = {
      directories = [
        "/var/lib/containers"
      ];
      data.directories = [
        ".local/share/containers"
      ];
    };
  };
}
