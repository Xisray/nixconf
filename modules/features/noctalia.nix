{
  self,
  inputs,
  config,
  ...
}:
{
  flake.nixosModules.noctalia = { pkgs, ... }: {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia;
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
          matches = [
            {
              app-id = "dev.noctalia.Noctalia";
            }
          ];
          open-floating = true;
        }
      ];

      wm.rules.layers = [
        {
          matches = [
            {
              namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
            }
          ];
          background-effect = {
            xray = false;
          };
        }
        {
          matches = [
            {
              namespace = "^noctalia-bar-secondary$";
            }
          ];
          background-effect = {
            blur = false;
          };
        }
        {
          matches = [
            {
              namespace = "^noctalia-backdrop";
            }
          ];
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

  perSystem = { lib, ... }: {
    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      settings =
        let
          monitors = builtins.filter (mon: mon.enable) (
            lib.mapAttrsToList (port: mon: mon // { port = port; }) config.preferences.monitors
          );
          primaryMonitor = lib.findFirst (m: m.primary) (builtins.head monitors) monitors;
          showSecondaryBar = builtins.length monitors > 1;
          parseMode =
            mode:
            let
              parts = lib.splitString "x" mode;
              width = (lib.toInt (builtins.head parts)) * 1.0;
              height = (lib.toInt (builtins.head (lib.splitString "@" (builtins.elemAt parts 1)))) * 1.0;
            in
            {
              inherit width height;
            };
          monitorSize =
            if primaryMonitor ? mode then
              parseMode primaryMonitor.mode
            else
              throw "Noctalia: ''mode' is not set for the primary monitor";

        in
        {
          backdrop.enabled = true;
          # hooks.started = "${lib.getExe pkgs.noctalia} msg session lock";
          shell.session.actions = [
            {
              action = "lock";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "1";
              variant = "default";
            }
            {
              action = "lock_and_suspend";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "2";
              variant = "default";
            }
            {
              action = "reboot";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "3";
              variant = "default";
            }
            {
              action = "shutdown";
              countdown_seconds = 0.0;
              enabled = true;
              shortcut = "4";
              variant = "default";
            }
            {
              action = "logout";
              countdown_seconds = 0.0;
              enabled = false;
              shortcut = "5";
              variant = "default";
            }
          ];
          desktop_widgets.enabled = false;
          dock.enabled = false;
          shell = {
            password_style = "random";
            polkit_agent = true;
            panel = {
              open_near_click_control_center = true;
              shadow = false;
              transparency_mode = "soft";
            };

            launcher.providers.session.global = true;
          };
          bar = {
            order = lib.optionals showSecondaryBar [
              "widgets"
              "secondary"
            ];
            widgets = {
              enabled = !showSecondaryBar;
              background_opacity = config.preferences.ui.opacity;
              shadow = false;
              center = [ "date" ];
              end = [
                "tray"
                "network"
                "bluetooth"
                "input_volume"
                "volume"
                "battery"
                "keyboard_layout"
                "notifications"
              ];
              margin_ends = 0;
              radius = 0;
              start = [
                "session"
                "workspaces"
                "audio_visualizer"
              ];
              concave_edge_corners = false;
            }
            // lib.optionalAttrs showSecondaryBar {
              monitor.${primaryMonitor}.enabled = true;
            };
          }
          // lib.optionalAttrs showSecondaryBar {
            secondary = {
              background_opacity = 0.0;
              capsule = true;
              capsule_fill = "on_primary";
              capsule_padding = 12.0;
              capsule_opacity = config.preferences.ui.opacity;
              center = [ "workspaces" ];
              concave_edge_corners = false;
              end = [ ];
              margin_ends = 0;
              radius = 0;
              shadow = false;
              start = [ ];
              dead_zone.actions.right = "none";
              monitor.${primaryMonitor}.enabled = false;
            };
          };
          osd = {
            background_opacity = config.preferences.ui.opacity;
          }
          // lib.optionalAttrs showSecondaryBar {
            monitors = [ primaryMonitor ];
          };
          notification.monitors = lib.optionals showSecondaryBar [ primaryMonitor ];
          lockscreen.monitors = lib.optionals showSecondaryBar [ primaryMonitor ];
          lockscreen_widgets = {
            enabled = true;
            widget_order = [
              "lockscreen_login_box@${primaryMonitor}"
              "lockscreen_widget_clock"
            ];
            widget = {
              "lockscreen_login_box@${primaryMonitor}" = {
                box_height = 70.0;
                box_width = 400.0;
                cx = monitorSize.width / 2;
                cy = monitorSize.height / 2;
                placement_height = monitorSize.height;
                placement_width = monitorSize.width;
                output = primaryMonitor;
                type = "login_box";
                settings = {
                  background_opacity = 0.0;
                  center_password_text = true;
                  input_opacity = config.preferences.ui.opacity;
                  layout = "compact";
                  show_caps_lock = true;
                  show_keyboard_layout = true;
                  show_login_button = false;
                  show_media = true;
                  show_session_buttons = true;
                  show_unlock_hint = false;
                  show_weather = false;
                };
              };
              lockscreen_widget_clock = {
                box_height = 112.0;
                box_width = 288.0;
                cx = monitorSize.width / 2;
                cy = monitorSize.height * 0.3 - 112.0;
                placement_height = monitorSize.height;
                placement_width = monitorSize.width;
                output = primaryMonitor;
                type = "clock";
                settings = {
                  background = false;
                  shadow = false;
                };
              };
            };
          };
          control_center = {
            sidebar = "none";
            sidebar_section = "none";
            hidden_tabs = [
              "media"
              "audio"
              "monitor"
              "system"
              "power"
              "network"
              "bluetooth"
              "weather"
              "calendar"
              "notifications"
              "screen-time"
            ];
            shortcuts = [
              {
                type = "caffeine";
              }
              {
                type = "wallpaper";
              }
            ];
          };

          widget = {
            brightness.show_label = false;
            date.format = "{::%H:%M %a, %b %d}";
            network.show_label = false;
            workspaces.show_labels = false;
            tray = {
              drawer = true;
              pinned = [
                "udiskie"
              ];
            };
            volume.show_label = false;
            input_volume.show_label = false;
          };
          nightlight.enabled = true;
          location = {
            sunrise = "07:00";
            sunset = "20:00";
            custom_schedule = true;
          };
          weather.enabled = false;

          theme.templates = {
            enable_builtin_templates = false;
            enable_community_templates = false;
          };

          wallpaper.directory = "/etc/wallpapers";
          idle = {
            behavior_order = [
              "lock"
              "screen-off"
              "lock-and-suspend"
            ];

            behavior = {
              lock = {
                action = "lock";
                enabled = true;
                timeout = 300.0;
              };
              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = true;
                timeout = 900.0;
              };

              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 600.0;
              };
            };
          };
        };
    };
  };
}
