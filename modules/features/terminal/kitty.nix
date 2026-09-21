{ inputs, ... }: {
  flake.terminals = {
    kitty = {
      wrap = inputs.wrapper-modules.wrappers.kitty.wrap;
      args = {
        settings = {
          window_padding_width = "0 10";
          enable_audio_bell = "no";
          cursor_shape = "beam";
          cursor_trail = 1;
          confirm_os_window_close = 0;
          shell_integration = "enabled";
        };
        keybindings = {
          "ctrl+1" = "goto_tab 1";
          "ctrl+2" = "goto_tab 2";
          "ctrl+3" = "goto_tab 3";
          "ctrl+4" = "goto_tab 4";
          "ctrl+5" = "goto_tab 5";
          "ctrl+6" = "goto_tab 6";
          "ctrl+7" = "goto_tab 7";
          "ctrl+8" = "goto_tab 8";
          "ctrl+9" = "goto_tab 9";
        };
      };
    };
  };
}
