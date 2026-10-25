{moduleWithSystem, ...}: {
  flake.nixosModules.utils = moduleWithSystem (
    {self', ...}: {
      config,
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
      homefs.files.".config/slurp/config.json" = lib.mkIf (config.appearance.scheme != null) {
        value = with config.appearance.colors.withHashtag; {
          borderColor = primary;
          selectionColor = "${primary}11";
        };
        generator = builtins.toJSON;
      };
      preferences.binds = {
        "Mod+Shift+C".action = colorpicker;
        "Mod+Shift+X" = {action = [(lib.getExe ocr)];};
        "Ctrl+Print" = {action = [(lib.getExe sshot)];};
        "Mod+Shift+S" = {action = [(lib.getExe sshot)];};
      };
    }
  );
}
