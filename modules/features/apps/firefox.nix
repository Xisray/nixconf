{self, ...}: {
  flake.nixosModules.firefox = {
    pkgs,
    config,
    ...
  }: let
    firefoxWrapper = self.wrappers.firefox or null;
    firefox =
      if (firefoxWrapper == null)
      then pkgs.firefox
      else if (config.appearance.scheme == null)
      then self.packages.${pkgs.stdenv.hostPlatform.system}.firefox
      else
        (firefoxWrapper.wrap {
          inherit pkgs;
          colors = with config.appearance.colors.withHashtag; {
            bookmark_text = base05;
            button_background_active = base02;
            button_background_hover = base01;
            icons = base05;
            icons_attention = base0D;
            frame = if config.appearance.base24 then base10 else base00;
            frame_inactive = if config.appearance.base24 then base10 else base00;
            ntp_background = base00;
            ntp_card_background = base01;
            ntp_text = base05;
            popup = base01;
            popup_border = base02;
            popup_highlight = base02;
            popup_highlight_text = base05;
            popup_text = base05;
            sidebar = base01;
            sidebar_border = base02;
            sidebar_highlight = base02;
            sidebar_highlight_text = base05;
            sidebar_text = base05;
            tab_background_separator = base02;
            tab_background_text = base04;
            tab_line = base0D;
            tab_loading = base0D;
            tab_selected = base00; # сливается с toolbar
            tab_text = base05;
            toolbar = base00;
            toolbar_bottom_separator = base02;
            toolbar_top_separator = base02;
            toolbar_vertical_separator = base02;
            toolbar_text = base05;
            toolbar_field = base01;
            toolbar_field_border = base02;
            toolbar_field_border_focus = base0D;
            toolbar_field_focus = base02;
            toolbar_field_highlight = base0D; # цвет выделения текста в адресной строке
            toolbar_field_highlight_text = base00;
            toolbar_field_separator = base02;
            toolbar_field_text = base05;
            toolbar_field_text_focus = base05;
          };
        });
  in {
    programs.firefox = {
      enable = true;
      package = firefox;
    };
    preferences = {
      wm.rules.windows = [
        {
          match.title = "^(Picture-in-Picture|Картинка в картинке)$";
          open-floating = true;
        }
      ];
      persistence = {
        data.directories = [
          ".mozilla"
          ".config/mozilla"
        ];
        cache.directories = [
          ".cache/mozilla"
        ];
      };
    };
  };
}
