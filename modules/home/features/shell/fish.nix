{ ... }: {
  flake.homeModules.fish = {
    programs.fish = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        la = "ls -a";
        lla = "ls -la";
        lt = "ls --tree";
      };
    };
  };
}
