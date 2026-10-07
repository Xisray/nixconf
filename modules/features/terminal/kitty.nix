{self, ...}: {
  flake.nixosModules.kitty = {
    pkgs,
    config,
    ...
  }: let
    kittyWrapper = self.wrappers.kitty or null;
    kitty =
      if kittyWrapper == null
      then pkgs.kitty
      else
        (
          if config.appearance.scheme == null
          then kittyWrapper
          else
            kittyWrapper.wrap {
              settings = with config.appearance.colors.withHashtag; {
                color0 = base03;
                color1 = base08;
                color2 = base0B;
                color3 = base0A;
                color4 = base0D;
                color5 =
                  if config.appearance.base24
                  then base17
                  else base0E;
                color6 = base0C;
                color7 = base05;
                color8 = base04;
                color9 = base08;
                color10 = base0B;
                color11 = base0A;
                color12 = base0D;
                color13 =
                  if config.appearance.base24
                  then base17
                  else base0E;
                color14 = base0C;
                color15 = base05;
                foreground = base05;
                background = base00;
                selection_foreground = base00;
                selection_background = base06;
                cursor = base06;
                cursor_text_color = base00;
                scrollbar_handle_color = base04;
                scrollbar_track_color = base03;
                url_color = base06;
                active_border_color = base07;
                inactive_border_color = base04;
                bell_border_color = base0A;
                wayland_titlebar_color = "system";
                macos_titlebar_color = "system";
                active_tab_foreground =
                  if config.appearance.base24
                  then base11
                  else base01;
                active_tab_background = base0E;
                inactive_tab_foreground = base05;
                inactive_tab_background = base01;
                tab_bar_background =
                  if config.appearance.base24
                  then base11
                  else base01;
                mark1_foreground = base00;
                mark1_background = base07;
                mark2_foreground = base00;
                mark2_background = base0E;
                mark3_foreground = base00;
                mark3_background =
                  if config.appearance.base24
                  then base16
                  else base0D;
                background_opacity = config.appearance.opacity.terminal;
              };
            }
        );
  in {
    preferences.binds."Mod+Return".action = kitty;
    xdg.terminal-exec = {
      enable = true;
      terminal-exec.setting.default = ["kitty.desktop"];
    };
    preferences.user.packages = [
      kitty
    ];
  };
}
