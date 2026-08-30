{ ... }: {
  flake.homeModules.fish = {
    programs.fish = {
      enable = true;
      shellAliases = {
        ls = "lsd";
        ll = "ls -l";
        la = "ls -a";
        lla = "ls -la";
        lt = "ls --tree";
      };
    };
    programs.zoxide.enableFishIntegration = true;
  };

  perSystem = { pkgs, ... }: {
    packages.shell = pkgs.fish;
  };
}
