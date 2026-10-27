{moduleWithSystem, ...}: {
  flake.nixosModules.kitty = moduleWithSystem ({self', ...}: {
    pkgs,
    lib,
    ...
  }: let
    kitty = self'.packages.kitty or pkgs.kitty;
  in {
    appearance.targets.kitty.enable = true;
    xdg.terminal-exec = {
      enable = true;
      settings.default = ["kitty.desktop"];
    };
    user.packages = [kitty];
    preferences = {
      binds."Mod+Return".action = lib.getExe kitty;
    };
  });
}
