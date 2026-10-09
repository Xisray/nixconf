{self, ...}: {
  flake.nixosModules.noctalia = {
    pkgs,
    config,
    lib,
    ...
  }: let
    style = config.appearance;
    monitors = builtins.filter (mon: mon.enable) (lib.mapAttrsToList (port: mon: mon // {port = port;}) config.preferences.monitors);
    monitor = lib.findFirst (m: m.primary) (builtins.head monitors) monitors;
    monitorPort = monitor.port;
    showSecondaryBar = builtins.length monitors > 1;
    noctalia = self.wrappers.noctalia or null;
  in {
    programs.noctalia =
      {
        enable = true;
        systemd.enable = true;
      }
      // lib.optionalAttrs (noctalia != null) {
        package = noctalia.wrap {
          inherit pkgs;
          colors = with style.colors.withHashtag; {
            mPrimary = base0E;
            mOnPrimary = base00;
            mSecondary = base07;
            mOnSecondary = base00;
            mTertiary = base0C;
            mOnTertiary = base00;
            mError = base08;
            mOnError = base00;
            mSurface = base00;
            mOnSurface = base05;
            mSurfaceVariant = base02;
            mOnSurfaceVariant = base04;
            mOutline = base04;
            mShadow = base00;
            mHover = base03;
            mOnHover = base05;
            terminal = {
              background = base00;
              foreground = base05;
              cursor = base06;
              cursorText = base00;
              selectionBg = base04;
              selectionFg = base05;
              normal = {
                black = base03;
                red = base08;
                green = base0B;
                yellow = base0A;
                blue = base0D;
                magenta = base09;
                cyan = base0C;
                white = base05;
              };
              bright = {
                black = base04;
                red = base08;
                green = base0B;
                yellow = base0A;
                blue = base0D;
                magenta = base09;
                cyan = base0C;
                white = base07;
              };
            };
          };
          settings =
            {
              osd.background_opacity = style.opacity.popups;
              notification.background_opacity = style.opacity.popups;

              shell.corner_radius_scale = lib.max 0.0 (lib.min 2.0 (style.rounding / 12.0));
              shell.panel.transparency_mode =
                if style.opacity.desktop < 1.0
                then "soft"
                else "solid";
              bar =
                {
                  default =
                    {
                      background_opacity = style.opacity.desktop;
                      radius_bottom_left = style.rounding;
                      radius_bottom_right = style.rounding;
                    }
                    // lib.optionalAttrs (style.rounding == 0) {
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
                    // lib.optionalAttrs (style.opacity.desktop < 1.0) {
                      capsule_opacity = style.opacity.desktop;
                    }
                    // lib.optionalAttrs (style.rounding == 0) {
                      capsule_radius = 0;
                    };
                };
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
                    settings =
                      {
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
                      // lib.optionalAttrs (style.opacity.desktop < 1.0) {
                        input_opacity = style.opacity.desktop;
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
            }
            // lib.optionalAttrs showSecondaryBar {
              osd.monitors = [monitorPort];
              notification.monitors = [monitorPort];
              lockscreen.monitors = [monitorPort];
            };
        };
      };
    preferences = {
      binds = let
        noctaliaBin = lib.getExe config.programs.noctalia.package;
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
  };
}
