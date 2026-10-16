{self, ...}: {
  flake.nixosModules.usb = {
    pkgs,
    lib,
    ...
  }: {
    services.udisks2.enable = true;
    systemd.user.services.udiskie = {
      description = "UDiskie mount daemon";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = lib.getExe (self.packages.${pkgs.stdenv.hostPlatform.system}.udiskie or pkgs.udiskie);
        Environment = [
          "PATH=%h/.nix-profile/bin:/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/run/current-system/sw/bin"
          "XDG_DATA_DIRS=%h/.local/share:%h/.nix-profile/share:/etc/profiles/per-user/%u/share:/run/current-system/sw/share"
        ];
        Restart = "on-failure";
      };
    };
  };
}
