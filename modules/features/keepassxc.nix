{ self, ... }: {
  flake.nixosModules.keepassxc = { pkgs, lib, ... }: {
    systemd.user.services.keepassxc = {
      Unit = {
        Description = "KeePassXC";
        PartOf = [ "graphical-session.target" ];
      };
      Service = 
      let
        keepassxc = self.packages.${pkgs.stdenv.hostPlatform.system}.keepassxc or pkgs.keepassxc;
      in {
        ExecStart = lib.getExe keepassxc;
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
