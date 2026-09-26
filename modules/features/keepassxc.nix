{ self, ... }: {
  flake.nixosModules.keepassxc = { pkgs, lib, ... }: 
  let
    keepassxc = self.packages.${pkgs.stdenv.hostPlatform.system}.keepassxc or pkgs.keepassxc;
  in {
    home = {
      packages = [
        keepassxc
      ];
      systemd.services.keepassxc = {
        enable = true;
        description = "KeePassXC";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = lib.getExe keepassxc;
          Restart = "on-failure";
        };
      };
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
