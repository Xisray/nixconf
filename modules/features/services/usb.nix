{self, ...}: {
  flake.nixosModules.usb = {
    pkgs,
    lib,
    ...
  }: let
    udiskie = self.packages.${pkgs.stdenv.hostPlatform.system}.udiskie or null;
  in {
    services.udisks2.enable = lib.mkIf (udiskie != null) true;
    systemd.packages = lib.mkIf (udiskie != null) [udiskie];
  };
}
