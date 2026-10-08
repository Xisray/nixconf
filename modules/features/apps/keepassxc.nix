{self, ...}: {
  flake.nixosModules.keepassxc = {pkgs, ...}: let
    keepassxc = self.packages.${pkgs.stdenv.hostPlatform.system}.keepassxc or pkgs.keepassxc;
  in {
    users.users.xisray.packages = [
      keepassxc
      (pkgs.makeAutostartItem {
        name = "keepassxc";
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
          match = {
            app-id = "^KeePassXC$";
            title = "^Unlock Database - KeePassXC$";
          };
          open-floating = true;
        }
      ];
    };
  };
}
