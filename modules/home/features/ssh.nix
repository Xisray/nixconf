{
  flake.homeModules.ssh = {
    programs.ssh = {
      enable = true;
      settings = {
        "github.com" = {
          HostName = "github.com";
          User = "git";
          ProxyCommand = "nc -X 5 -x 127.0.0.1:7897 %h %p";
        };
      };
    };
  };
}
