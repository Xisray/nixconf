{
  flake.nixosModules.clash-verge = {
    programs.clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = false;
    };
    preferences.persistence = {
      data.directories = [
        ".local/share/io.github.clash-verge-rev.clash-verge-rev"
      ];
      cache.directories = [
        ".cache/io.github.clash-verge-rev.clash-verge-rev"
      ];
    };
  };
}
