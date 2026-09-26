{ self, ... }: {
  flake.nixosModules.usb = { lib, pkgs, ... }:
  let
    udiskie = self.packages.${pkgs.stdenv.hostPlatform.system}.udiskie or pkgs.udiskie;
  in {
    services.udisks2.enable = true;
    home = {
      packages = [
        udiskie
      ];
      systemd.services.udiskie = {
        enable = true;
        description = "UDiskie mount daemon";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        # requires = [ "tray.target" ];
        serviceConfig = {
          ExecStart = lib.getExe udiskie;
          Restart = "on-failure";
        };
      };
    };
  };
}
