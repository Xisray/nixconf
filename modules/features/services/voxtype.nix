{self, ...}: {
  flake.nixosModules.voxtype = {
    pkgs,
    lib,
    ...
  }: let
    voxtype = self.packages.${pkgs.stdenv.hostPlatform.system}.voxtype or null;
  in {
    systemd.packages = lib.mkIf (voxtype != null) [voxtype];
    preferences = lib.mkIf (voxtype != null) {
      user.packages = [voxtype];
      binds."Pause".action = [
        (lib.getExe voxtype)
        "record"
        "toggle"
      ];
    };
  };
}
