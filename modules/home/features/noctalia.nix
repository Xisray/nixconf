{
  flake.homeModules.noctalia =
    {
      lib,
      pkgs,
      ...
    }:
    {
      #preferences.autostart = [ "noctalia" ];

      preferences.binds."Mod+S".action = "${lib.getExe pkgs.noctalia} msg panel-toggle launcher";

      preferences.binds."XF86MonBrightnessUp" = {
        props.allow-when-locked = true;
        action = "${lib.getExe pkgs.noctalia} msg brightness-up";
      };
      preferences.binds."XF86MonBrightnessDown" = {
        props.allow-when-locked = true;
        action = "${lib.getExe pkgs.noctalia} msg brightness-down";
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
            shadow = false;
            center = [ "date" ];
            end = [
              "tray"
              "network"
              "bluetooth"
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
            date.format = "{::%H:%m %a, %b %d}";
            network.show_label = false;
            workspaces.show_labels = false;
            tray = {
              drawer = true;
              pinned = [
                "udiskie"
              ];
            };
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
