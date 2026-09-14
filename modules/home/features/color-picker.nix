{
  flake.homeModules.colorPicker = { pkgs, lib, ... }: {
    preferences.binds."Mod+Shift+C".action = [
      (lib.getExe pkgs.hyprpicker)
      "-a"
      "-n"
    ];
  };
}
