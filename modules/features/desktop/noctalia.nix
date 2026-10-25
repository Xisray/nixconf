{moduleWithSystem, ...}: {
  flake.nixosModules.noctalia = moduleWithSystem ({self', ...}: {
    pkgs,
    config,
    lib,
    ...
  }: let
    style = config.appearance;
    monitors = builtins.filter (mon: mon.enable) (
      lib.mapAttrsToList (port: mon: mon // {port = port;}) config.preferences.monitors
    );
    monitor = lib.findFirst (m: m.primary) (builtins.head monitors) monitors;
    monitorPort = monitor.port;
    showSecondaryBar = builtins.length monitors > 1;
    noctalia = self'.packages.noctalia or pkgs.noctalia;
  in {
    homefs.files.".config/noctalia/config.toml" = let
      merge = lib.foldl' lib.recursiveUpdate {};
      translucent = style.opacity.desktop < 1.0;
      square = style.rounding == 0;
      loginBox = "lockscreen_login_box@${monitorPort}";
      base = {
        wallpaper.directory = "~/Pictures/Wallpapers";
        bar.default = {
          background_opacity = style.opacity.desktop;
          radius_bottom_left = style.rounding;
          radius_bottom_right = style.rounding;
        };
        lockscreen_widgets = {
          enabled = true;
          widget_order = [loginBox "lockscreen_widget_clock"];
          widget = {
            ${loginBox} = {
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
      };
      squareCorners = lib.optionalAttrs square {
        bar.default.capsule_radius = 0;
      };
      translucency = lib.optionalAttrs translucent {
        lockscreen_widgets.widget.${loginBox}.settings.input_opacity = style.opacity.desktop;
      };
      secondaryBar = lib.optionalAttrs showSecondaryBar {
        osd.monitors = [monitorPort];
        notification.monitors = [monitorPort];
        lockscreen.monitors = [monitorPort];
        bar = {
          order = ["default" "secondary"];
          default = {
            enabled = false;
            monitor.${monitorPort}.enabled = true;
          };
          secondary =
            {
              background_opacity = 0.0;
              capsule = true;
              capsule_fill = "on_primary";
              capsule_padding = 12.0;
              center = ["workspaces"];
              concave_edge_corners = false;
              end = [];
              margin_ends = 0;
              radius = 0;
              shadow = false;
              start = [];
              dead_zone.actions.right = "none";
              monitor.${monitorPort}.enabled = false;
            }
            // lib.optionalAttrs translucent {capsule_opacity = style.opacity.desktop;}
            // lib.optionalAttrs square {capsule_radius = 0;};
        };
      };
    in
      (pkgs.formats.toml {}).generate "noctalia.toml" (merge [base squareCorners translucency secondaryBar]);
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      package = noctalia;
    };
    preferences = {
      binds = let
        noctaliaBin = lib.getExe noctalia;
      in {
        "Mod+S".action = [
          noctaliaBin
          "msg"
          "panel-toggle"
          "launcher"
        ];
        "Mod+Comma".action = [
          noctaliaBin
          "msg"
          "settings-toggle"
        ];
        "XF86MonBrightnessUp" = {
          allowLocked = true;
          action = [
            noctaliaBin
            "msg"
            "brightness-up"
          ];
        };
        "XF86MonBrightnessDown" = {
          allowLocked = true;
          action = [
            noctaliaBin
            "msg"
            "brightness-down"
          ];
        };
        "Mod+Shift+E" = {
          action = let
            annotateClipboard = pkgs.writeShellScript "annotate-clipboard" ''
              f="$(mktemp --suffix=.png -p "''${XDG_RUNTIME_DIR:-/tmp}" screenshot-XXXXXX)"
              if ! ${pkgs.wl-clipboard}/bin/wl-paste --type image/png > "$f" || [ ! -s "$f" ]; then
                rm -f "$f"
                exit 1
              fi
              exec ${noctaliaBin} msg annotate "$f"
            '';
          in "${annotateClipboard}";
          shell = true;
        };
      };
      wm.rules = {
        windows = [
          {
            match.app-id = "dev.noctalia.Noctalia";
            open-floating = true;
          }
        ];
        layers =
          [
            {
              matches.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
              background-effect.xray = false;
            }
            {
              matches.namespace = "^noctalia-backdrop";
              place-within-backdrop = true;
            }
          ]
          ++ lib.optional showSecondaryBar {
            matches.namespace = "^noctalia-bar-secondary$";
            background-effect.blur = false;
          };
      };
      persistence.data.directories = [
        ".local/state/noctalia"
      ];
      persistence.cache.directories = [
        ".cache/noctalia"
      ];
    };
  });
}
