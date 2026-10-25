{moduleWithSystem, ...}: {
  flake.nixosModules.voxtype = moduleWithSystem ({self', ...}: {lib, ...}: let
    voxtype = self'.packages.voxtype;
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
  });
}
