{
  flake.nixosModules.usb = {
    services.udisks2.enable = true;
    systemd.user.services.udiskie = {
      enable = true;
      description = "UDiskie automounter";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs.udiskie} --smart-tray";
        Restart = "on-failure";
      };
    };
  };
}
