{
  flake.homeModules.general = { pkgs, ... }: {
    home.packages = with pkgs; [
      devenv
    ];
    xsession.preferStatusNotifierItems = true;
    services.udiskie = {
      enable = true;
      tray = "always";
      notify = true;
    };
  };
}
