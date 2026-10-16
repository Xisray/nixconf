{self, ...}: {
  flake.nixosModules.utils = {
    config,
    lib,
    pkgs,
    ...
  }: let
    slurpWrapper = self.wrappers.slurp or null;
    slurp =
      if (slurpWrapper == null || config.appearance.scheme == null)
      then null
      else
        (slurpWrapper.wrap {
          inherit pkgs;
          settings.colors = with config.appearance.colors.withHashtag; {
            border = primary;
            selection = "${primary}11";
          };
        });

    colorpicker = [(lib.getExe (self.packages.${pkgs.stdenv.hostPlatform.system}.hyprpicker or pkgs.hyprpicker)) "-a" "--scale=2.0" "--radius=100"];
    ocrWrapper = self.wrappers.ocr or null;
    ocr =
      if (ocrWrapper == null)
      then null
      else if (slurp == null)
      then self.packages.${pkgs.stdenv.hostPlatform.system}.ocr
      else
        (ocrWrapper.wrap {
          inherit pkgs;
          settings.slurp = slurp;
        });

    sshotWrapper = self.wrappers.sshot or null;
    sshot =
      if (sshotWrapper == null)
      then null
      else if (slurp == null)
      then self.packages.${pkgs.stdenv.hostPlatform.system}.sshot
      else
        (sshotWrapper.wrap {
          inherit pkgs;
          settings.slurp = slurp;
        });
  in {
    preferences.binds = {
      "Mod+Shift+C".action = colorpicker;
      "Mod+Shift+X" = lib.mkIf (ocr != null) {action = [(lib.getExe ocr)];};
      "Ctrl+Print" = lib.mkIf (sshot != null) {action = [(lib.getExe sshot)];};
      "Mod+Shift+S" = lib.mkIf (sshot != null) {action = [(lib.getExe sshot)];};
    };
  };
}
