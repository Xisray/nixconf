{
  self,
  ...
}:
{
  flake.nixosModules.noctalia =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        package = (self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia or pkgs.noctalia);
      };
      preferences = {
        binds =
          let
            noctalia = config.programs.noctalia.package;
          in
          {
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

      home.files.".config/noctalia/settings.toml" = {
        generator = (pkgs.formats.toml { }).generate "settings.toml";
        value =
          let
            cfg = config.preferences;
            monitors = builtins.filter (mon: mon.enabled) (
              lib.mapAttrsToList (port: mon: mon // { port = port; }) cfg.monitors
            );
            monitor = lib.findFirst (m: m.primary) (builtins.head monitors) monitors;
            showSecondaryBar = builtins.length monitors > 1;
            monitorPort = monitor.port;
            hasOpacity = cfg.ui.opacity < 1.0;
          in
          {
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
                    input_opacity = cfg.ui.opacity;
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
            shell.corner_radius_scale = lib.max 0.0 (lib.min 2.0 (cfg.ui.corner.radius / 12.0));
            bar = {
            }
            // lib.optionalAttrs showSecondaryBar {
              order = [
                "widgets"
                "secondary"
              ];
              widgets = {
                enabled = false;
                monitor.${monitorPort}.enabled = true;
                capsule_radius = cfg.ui.corner.radius;
              };
              secondary = {
                background_opacity = 0.0;
                capsule = true;
                capsule_radius = cfg.ui.corner.radius;
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
                capsule_opacity = cfg.ui.opacity;
              };
            };
          }
          // lib.optionalAttrs showSecondaryBar {
            osd.monitors = [ monitorPort ];
            notification.monitors = [ monitorPort ];
            lockscreen.monitors = [ monitorPort ];
          }
          // lib.optionalAttrs hasOpacity {
            shell.panel.transparency_mode = "soft";
            bar.widgets.background_opacity = cfg.ui.opacity;
            osd.background_opacity = cfg.ui.opacity;
            notification.background_opacity = cfg.ui.opacity;
          };
      };
    };
}
