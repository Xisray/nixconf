{
  flake.nixosModules.docker = {
    virtualisation.docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    preferences.persistence.data.directories = [
      ".local/share/docker"
      ".config/docker"
    ];
  };
}
