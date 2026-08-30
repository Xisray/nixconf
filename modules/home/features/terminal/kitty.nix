{ pkgs, ... }: {
  flake.homeModules.kitty = {
    programs.kitty = {
      enable = true;
      font = {
        name = "monospace";
        size = 15;
      };

      settings = {
        enable_audio_bell = "no";
        cursor_shape = "beam";
        cursor_trail = 1;
        confirm_os_window_close = 0;
        shell_integration = "enabled";
      };
    };
  };
  perSystem = { pkgs, ... }: {
    packages.terminal = pkgs.kitty;
  };
}
