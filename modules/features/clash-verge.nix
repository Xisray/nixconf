 {
  flake.nixosModules.clashVerge = {
    programs.clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = true;
    };
    home.xdg.mime-apps.default-applications = {
      "x-scheme-handler/clash" = "clash-verge.desktop";
      "x-scheme-handler/clash-verge" = "clash-verge.desktop";
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
