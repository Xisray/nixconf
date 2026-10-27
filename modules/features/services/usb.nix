{moduleWithSystem, ...}: {
  flake.nixosModules.usb = moduleWithSystem ({self', ...}: {lib, ...}: let
    udiskie = self'.packages.udiskie;
  in {
    services.udisks2.enable = true;
    systemd.packages = [udiskie];
    user.packages = [udiskie];
  });
}
