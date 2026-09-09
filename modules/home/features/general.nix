{
  flake.homeModules.general = { pkgs, ... }: {
    home.packages = with pkgs; [
      devenv
    ];
    services.udiskie = {
      enable = true;
    };
  };
}
