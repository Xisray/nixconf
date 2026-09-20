{
  flake.homeModules.noctalia =
    {
      osConfig,
      lib,
      pkgs,
      ...
    }:
    let
      monitors = osConfig.preferences.monitors or [ ];
      primaryMonitorEntry =
        if monitors == [ ] then
          throw "noctalia: osConfig.preferences.monitors пуст — должен быть задан хотя бы один монитор"
        else
          let
            withPrimaryAndPort = lib.findFirst (m: (m.primary or false) && (m ? port)) null monitors;
            anyWithPort = lib.findFirst (m: m ? port) null monitors;
          in
          if withPrimaryAndPort != null then
            withPrimaryAndPort
          else if anyWithPort != null then
            anyWithPort
          else
            throw "noctalia: ни у одного монитора в osConfig.preferences.monitors не задан 'port'";

      primaryMonitor = primaryMonitorEntry.port;

      showSecondaryBar = builtins.length monitors > 1;

      toFloat = x: x * 1.0;

      parseMode =
        mode:
        let
          parts = lib.splitString "x" mode;
          width = toFloat (lib.toInt (builtins.elemAt parts 0));
          heightPart = builtins.elemAt parts 1;
          height = toFloat (lib.toInt (builtins.head (lib.splitString "@" heightPart)));
        in
        {
          inherit width height;
        };

      dims =
        if primaryMonitorEntry ? mode then
          parseMode primaryMonitorEntry.mode
        else
          throw "noctalia: у основного монитора не задан 'mode'";

      clearLockscreenState =
        pkgs.writers.writePython3 "noctalia-clear-lockscreen-state"
          {
            libraries = [ pkgs.python3Packages.tomlkit ];
          }
          ''
            import sys
            from pathlib import Path
            import tomlkit

            path = Path.home() / ".local/state/noctalia/settings.toml"
            if not path.exists():
                sys.exit(0)

            doc = tomlkit.parse(path.read_text())

            keys_to_reset = ["lockscreen_widgets"]

            changed = False
            for key in keys_to_reset:
                if key in doc:
                    del doc[key]
                    changed = True

            if changed:
                path.write_text(tomlkit.dumps(doc))
          '';
    in
    {
      home.activation.noctaliaClearLockscreenState = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${clearLockscreenState}
        $DRY_RUN_CMD systemctl --user try-restart noctalia.service 2>/dev/null || true
      '';
      preferences.binds = {
        "Mod+S".action = "${lib.getExe pkgs.noctalia} msg panel-toggle launcher";
        "Mod+Comma".action = "${lib.getExe pkgs.noctalia} msg settings-toggle";

        "XF86MonBrightnessUp" = {
          props.allow-when-locked = true;
          action = "${lib.getExe pkgs.noctalia} msg brightness-up";
        };
        "XF86MonBrightnessDown" = {
          props.allow-when-locked = true;
          action = "${lib.getExe pkgs.noctalia} msg brightness-down";
        };
      };

      preferences.persistance.data.directories = [
        ".local/state/noctalia"
      ];

      preferences.persistance.cache.directories = [
        ".cache/noctalia"
      ];

      preferences.windowRules = [
        {
          matches = [
            {
              app-id = "dev.noctalia.Noctalia";
            }
          ];
          open-floating = true;
        }
      ];

      preferences.layerRules = [
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

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
          backdrop.enabled = true;
          hooks.started = "${lib.getExe pkgs.noctalia} msg session lock";
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
              background_opacity = osConfig.stylix.opacity.desktop;
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
              capsule_opacity = osConfig.stylix.opacity.desktop;
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
            background_opacity = osConfig.stylix.opacity.desktop;
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
                cx = dims.width / 2;
                cy = dims.height / 2;
                placement_height = dims.height;
                placement_width = dims.width;
                output = primaryMonitor;
                type = "login_box";
                settings = {
                  background_opacity = 0.0;
                  center_password_text = true;
                  input_opacity = osConfig.stylix.opacity.desktop;
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
                cx = dims.width / 2;
                cy = dims.height * 0.3 - 112.0;
                placement_height = dims.height;
                placement_width = dims.width;
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
