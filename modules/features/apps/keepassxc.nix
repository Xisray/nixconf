{moduleWithSystem, ...}: {
  flake.nixosModules.keepassxc = moduleWithSystem ({self', ...}: {pkgs, ...}: let
    keepassxc = self'.packages.keepassxc or pkgs.keepassxc;
  in {
    user.packages = [
      keepassxc
      (pkgs.makeAutostartItem {
        name = "org.keepassxc.KeePassXC";
        package = keepassxc;
      })
    ];
    programs.firefox.nativeMessagingHosts.packages = [keepassxc];
    preferences = {
      persistence.cache.directories = [
        ".cache/keepassxc"
      ];
      wm.rules.windows = [
        {
          match.title = "^Unlock Database - KeePassXC$";
          open-floating = true;
        }
      ];
    };
  });
}
