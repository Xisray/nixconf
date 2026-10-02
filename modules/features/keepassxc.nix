{ self, ... }: {
  flake.nixosModules.keepassxc = { pkgs, ... }: {
    home.programs.keepassxc = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.keepassxc or pkgs.keepassxc;
      systemd.enable = true;
    };
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
