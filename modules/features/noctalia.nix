{ self, ... }: {
  flake.nixosModules.noctalia =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      noctalia = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia or pkgs.noctalia;
    in
    {
      home.programs.noctalia = {
        enable = true;
        systemd.enable = true;
        package = noctalia;
        settings =
          let
            cfg = config.preferences;
            theme = cfg.theme;
            monitors = builtins.filter (mon: mon.enable) (
              lib.mapAttrsToList (port: mon: mon // { port = port; }) cfg.monitors
            );
            monitor = lib.findFirst (m: m.primary) (builtins.head monitors) monitors;
            showSecondaryBar = builtins.length monitors > 1;
            monitorPort = monitor.port;
            hasOpacity = theme.opacity < 1.0;
          in
          {
            osd.background_opacity = theme.opacity;
            notification.background_opacity = theme.opacity;
            shell.corner_radius_scale = lib.max 0.0 (lib.min 2.0 (theme.corner.radius / 12.0));
            shell.panel.transparency_mode = if theme.opacity < 1.0 then "soft" else "solid";
            lockscreen_widgets = {
              enabled = true;
              widget_order = [
                "lockscreen_login_box@${monitorPort}"
                "lockscreen_widget_clock"
              ];
              widget = {
                "lockscreen_login_box@${monitorPort}" = {
                  box_height = 70.0;
                  box_width = 400.0;
                  cx = monitor.width / 2;
                  cy = monitor.height / 2;
                  placement_height = monitor.height;
                  placement_width = monitor.width;
                  output = monitorPort;
                  type = "login_box";
                  settings = {
                    background_opacity = 0.0;
                    center_password_text = true;
                    layout = "compact";
                    show_caps_lock = true;
                    show_keyboard_layout = true;
                    show_login_button = false;
                    show_media = true;
                    show_session_buttons = true;
                    show_unlock_hint = false;
                    show_weather = false;
                  }
                  // lib.optionalAttrs hasOpacity {
                    input_opacity = theme.opacity;
                  };
                };
                lockscreen_widget_clock = {
                  box_height = 112.0;
                  box_width = 288.0;
                  cx = monitor.width / 2;
                  cy = monitor.height * 0.3 - 112.0;
                  placement_height = monitor.height;
                  placement_width = monitor.width;
                  output = monitorPort;
                  type = "clock";
                  settings = {
                    background = false;
                    shadow = false;
                  };
                };
              };
            };
            bar = {
              default = {
                background_opacity = theme.opacity;
              }
              // lib.optionalAttrs (theme.corner.radius == 0) {
                capsule_radius = 0;
              }
              // lib.optionalAttrs showSecondaryBar {
                enabled = false;
                monitor.${monitorPort}.enabled = true;
              };
            }
            // lib.optionalAttrs showSecondaryBar {
              order = [
                "default"
                "secondary"
              ];
              secondary = {
                background_opacity = 0.0;
                capsule = true;
                capsule_fill = "on_primary";
                capsule_padding = 12.0;
                center = [ "workspaces" ];
                concave_edge_corners = false;
                end = [ ];
                margin_ends = 0;
                radius = 0;
                shadow = false;
                start = [ ];
                dead_zone.actions.right = "none";
                monitor.${monitorPort}.enabled = false;
              }
              // lib.optionalAttrs hasOpacity {
                capsule_opacity = theme.opacity;
              }
              // lib.optionalAttrs (theme.corner.radius == 0) {
                capsule_radius = 0;
              };
            };
          }
          // lib.optionalAttrs showSecondaryBar {
            osd.monitors = [ monitorPort ];
            notification.monitors = [ monitorPort ];
            lockscreen.monitors = [ monitorPort ];
          };

      };
      preferences = {
        theme.provider = "noctalia";
        binds = {
          "Mod+S".action = [
            noctalia
            "msg"
            "panel-toggle"
            "launcher"
          ];
          "Mod+Comma".action = [
            noctalia
            "msg"
            "settings-toggle"
          ];

          "XF86MonBrightnessUp" = {
            allowLocked = true;
            action = [
              noctalia
              "msg"
              "brightness-up"
            ];
          };
          "XF86MonBrightnessDown" = {
            allowLocked = true;
            action = [
              noctalia
              "msg"
              "brightness-down"
            ];
          };
        };
        wm.rules.windows = [
          {
            match.app-id = "dev.noctalia.Noctalia";
            open-floating = true;
          }
        ];

        wm.rules.layers = [
          {
            matches.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
            background-effect.xray = false;
          }
          {
            matches.namespace = "^noctalia-bar-secondary$";
            background-effect.blur = false;
          }
          {
            matches.namespace = "^noctalia-backdrop";
            place-within-backdrop = true;
          }
        ];
        persistence.data.directories = [
          ".local/state/noctalia"
        ];

        persistence.cache.directories = [
          ".cache/noctalia"
        ];
      };
    };
}
