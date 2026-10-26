{
  flake.nixosModules.clash-verge = {
    programs.clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = false;
    };
    fpatcher.clash-verge = {
      path = ".local/share/io.github.clash-verge-rev.clash-verge-rev/verge.yaml";
      format = "yaml";
      content = {
        auto_check_update = false;
        enable_auto_launch = false;
        enable_silent_start = true;
      };
    };
    preferences = {
      proxy = {
        https = "http://127.0.0.1:7897";
        http = "http://127.0.0.1:7897";
        all = "socks5h://127.0.0.1:7897";
      };
      persistence = {
        data.directories = [
          ".local/share/io.github.clash-verge-rev.clash-verge-rev"
        ];
        cache.directories = [
          ".cache/io.github.clash-verge-rev.clash-verge-rev"
        ];
      };
    };
  };
}
