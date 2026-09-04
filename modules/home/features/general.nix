{
  flake.homeModules.general = { pkgs, ... }: {
    home.packages = with pkgs; [
      devenv
    ];
  };
}
