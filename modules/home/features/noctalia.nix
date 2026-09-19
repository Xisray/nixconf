{
  flake.homeModules.noctalia =
    {
      osConfig,
      lib,
      pkgs,
      ...
    }:
    {
      preferences.binds = {
        "Mod+S".action = "${lib.getExe pkgs.noctalia} msg panel-toggle launcher";

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

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
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
            };

            launcher.providers.session.global = true;
          };
          bar.widgets = {
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
