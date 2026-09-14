{ inputs, ... }: {
  flake.homeModules.colorPicker =
    { pkgs, lib, ... }:
    let
      hyprpicker = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.hyprpicker;
        runtimePkgs = with pkgs; [
          wl-clipboard
          libnotify
        ];
      };
    in
    {
      preferences.binds."Mod+Shift+C".action = [
        (lib.getExe hyprpicker)
        "-a"
        "-n"
        "--scale=2.0"
        "--radius=100"
      ];
    };
}
