{ self, ... }: {
  flake.nixosModules.usb = { lib, pkgs, ... }: {
    services.udisks2.enable = true;
    systemd.user.services.udiskie = {
      enable = true;
      description = "UDiskie automounter";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe (self.packages.${pkgs.stdenv.hostPlatform.system}.udiskie or pkgs.udiskie)} --smart-tray";
        Restart = "on-failure";
      };
    };
  };
}
