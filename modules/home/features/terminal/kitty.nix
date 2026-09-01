{ ... }: {
  flake.homeModules.kitty = { pkgs, lib, ... }: {
    programs.kitty = {
      enable = true;
      settings = {
        enable_audio_bell = "no";
        cursor_shape = "beam";
        cursor_trail = 1;
        confirm_os_window_close = 0;
        shell_integration = "enabled";
      };
    };
    preferences.binds."Mod+Return".action = lib.getExe pkgs.kitty;
  };
}
