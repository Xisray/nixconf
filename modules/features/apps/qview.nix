{
  flake.nixosModules.qview = {
    pkgs,
    config,
    ...
  }: {
    user.packages = [
      pkgs.qview
    ];
    fpatcher.qview = {
      user = config.preferences.user.name;
      path = ".config/qView/qView.conf";
      format = "ini";
      content = {
        options = {
          bgcolorenabled = false;
          windowresizemode = 0;
        };
        General.firstlaunch = true;
      };
    };
  };
}
