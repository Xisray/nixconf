{
  flake.nixosModules.clash-verge = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = false;
    };
    fpatcher.clash-verge = {
      user = config.preferences.user.name;
      path = ".local/share/io.github.clash-verge-rev.clash-verge-rev/verge.yaml";
      format = "yaml";
      content = {
        auto_check_update = false;
        enable_auto_launch = false;
        enable_silent_start = true;
        theme_setting =
          if (config.appearance.scheme != null)
          then
            (with config.appearance.colors.withHashtag; {
              primary_color = primary;
              secondary_color = secondary;
              primary_text = base05;
              secondary_text = base06;
              info_color = base0D;
              error_color = base08;
              warning_color = base09;
              success_color = base0B;
              css_injection = "*{--Paper-overlay:none !important;--scrollbar-bg:none;--card:${base01};--bg:${base00};--dialog:${base02};--dialog-outline: none;--background-color:${base00} !important;${lib.optionalString (config.appearance.rounding == 0) "border-radius:0 !important;"}}:not(.Mui-checked)+.MuiSwitch-track{background-color:var(--bg) !important;}.MuiList-root.MuiMenu-list{background-color: var(--bg) !important;}.MuiBox-root>.MuiBox-root{background-color:transparent !important;}#root,#root>div.MuiPaper-root.MuiPaper-elevation.MuiPaper-elevation0.linux{background-color:var(--bg) !important;}.css-3e4wjh,.css-1pgrx25,.css-aafiep,.css-jtgpy6,.css-xd8r7u,.css-hds0vx,.css-bjjbb7,.css-1mxksna,.css-1tg4gst,.css-q2msz6,.css-um6u34,.css-14aadh2,.css-1j1wdi0,.css-hjl7fk,.css-1u2bb7u,.css-1dxee5s,.css-6892g4,.css-zt326n{background-color:var(--card);}.css-wdyvh4,.css-oc745q,.css-1c3hbyo,.MuiDialog-paper,.css-r94ymm{background-color:var(--dialog) !important;outline:var(--dialog-outline) !important;}.css-17rlh6j{background-color:transparent !important;}.base-container section,.css-l3ykv8{background-color:var(--bg) !important;}";
            })
          else {css_injection = "*{${lib.optionalString (config.appearance.rounding == 0) "border-radius:0 !important;"}}";};
      };
      before = ''
        was_running=0
        if pgrep -f '^clash-verge$' >/dev/null; then
          was_running=1
          pkill -f '^clash-verge$' || true
          # ждём завершения (до ~10 с): при выходе приложение перезаписывает verge.yaml
          for _ in $(seq 50); do
            pgrep -f '^clash-verge$' >/dev/null || break
            sleep 0.2
          done
        fi
      '';
      after = ''
        if [ "$was_running" = 1 ]; then
          uid=$(id -u)
          export XDG_RUNTIME_DIR=/run/user/$uid
          export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus
          export WAYLAND_DISPLAY=wayland-1
          ${pkgs.util-linux}/bin/setsid -f ${pkgs.clash-verge-rev}/bin/clash-verge >/dev/null 2>&1 || true
        fi
      '';
    };
    preferences = {
      proxy = {
        https = "http://127.0.0.1:7897";
        http = "http://127.0.0.1:7897";
        all = "socks5h://127.0.0.1:7897";
      };
      persistence = {
        data.directories = [
          ".local/share/io.github.clash-verge-rev.clash-verge-rev"
        ];
        cache.directories = [
          ".cache/io.github.clash-verge-rev.clash-verge-rev"
        ];
      };
    };
  };
}
