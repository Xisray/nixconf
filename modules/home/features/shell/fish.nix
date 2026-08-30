{ inputs, ... }: {
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
  perSystem = { pkgs, ... }: {
    packages.shell = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;
      runtimePkgs = with pkgs; [
        fzf
        ripgrep
        lsd
        bat
        zoxide
        fd
        btop
        yazi
      ];
    };
  };
}
