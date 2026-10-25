{moduleWithSystem, ...}: {
  flake.nixosModules.usb = moduleWithSystem ({self', ...}: {lib, ...}: let
    udiskie = self'.packages.udiskie;
  in {
    services.udisks2.enable = lib.mkIf (udiskie != null) true;
    systemd.packages = lib.mkIf (udiskie != null) [udiskie];
    user.packages = lib.mkIf (udiskie != null) [udiskie];
  });
}
