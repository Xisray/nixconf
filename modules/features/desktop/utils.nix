{moduleWithSystem, ...}: {
  flake.nixosModules.utils = moduleWithSystem (
    {self', ...}: {
      lib,
      pkgs,
      ...
    }: let
      colorpicker = [
        (lib.getExe (self'.packages.hyprpicker or pkgs.hyprpicker))
        "-a"
        "--scale=2.0"
        "--radius=100"
      ];
      ocr = self'.packages.ocr;
      sshot = self'.packages.sshot;
    in {
      appearance.targets.slurp.enable = true;
      preferences.binds = {
        "Mod+Shift+C".action = colorpicker;
        "Mod+Shift+X" = {action = [(lib.getExe ocr)];};
        "Ctrl+Print" = {action = [(lib.getExe sshot)];};
        "Mod+Shift+S" = {action = [(lib.getExe sshot)];};
      };
    }
  );
}
