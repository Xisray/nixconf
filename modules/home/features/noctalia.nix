{ self, inputs, ... }: {
  flake.homeModules.noctalia = { lib, pkgs, ... }: {
    preferences.autostart = [ "noctalia" ];

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
      settings = {
        desktop_widgets.enabled = false;
        dock.enabled = false;
        shell = {
          password_style = "random";
          polkit_agent = true;
        };
        bar.widgets = {
          center = [ "date" ];
          end = [
            "tray"
            "network"
            "bluetooth"
            "volume"
            "battery"
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
            "wifi"
            "bluetooth"
            "caffeine"
            "notification"
            "power_profile"
            "wallpaper"
          ];
        };

        widget.brightness = {
          show_label = false;
        };

        widget.date = {
          format = "{::%H:%m %a, %b %d}";
        };

        widget.network = {
          show_label = false;
        };

        widget.workspaces = {
          show_labels = false;
        };

        widget.tray.drawer = true;

        nightlight.enabled = true;
        weather.enable = false;

        theme.templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };

        wallpaper.directory = "~/Pictures/Wallpapers";
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
