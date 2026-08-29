{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.kitty = inputs.wrapper-modules.wrappers.kitty.wrap {
      inherit pkgs;
      settings = {
        enable_audio_bell = "no";
        cursor_shape = "beam";
        cursor_trail = 1;
        confirm_os_window_close = 0;
        shell_integration = "enabled";
        font_size = 15;
        font_family = "JetBrainsMono Nerd Font";

        background = self.theme.base00;
        foreground = self.theme.base07;

        cursor = self.theme.base07;

        selection_foreground = self.theme.base02;
        selection_background = self.theme.base01;

        active_tab_foreground = self.theme.base0B;
        active_tab_background = self.theme.base03;
        inactive_tab_background = self.theme.base01;

        color0 = self.theme.base00;
        color8 = self.theme.base02;
        color1 = self.theme.base08;
        color9 = self.theme.base08;
        color2 = self.theme.base0B;
        color10 = self.theme.base0B;
        color3 = self.theme.base0A;
        color11 = self.theme.base0A;
        color4 = self.theme.base0D;
        color12 = self.theme.base0D;
        color5 = self.theme.base0E;
        color13 = self.theme.base0E;
        color6 = self.theme.base0C;
        color14 = self.theme.base0C;
        color7 = self.theme.base03;
        color15 = self.theme.base03;
      };
    };
  };
}
