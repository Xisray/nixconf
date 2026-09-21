{
  self,
  inputs,
  config,
  ...
}:
{
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };
  };
  perSystem = { pkgs, lib, ... }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      settings = {
        blur =
          if config.preferences.blur.enable then
            {
              passes = 2;
              offset = 3.0;
              noise = 0.03;
              saturation = 1.0;
            }
          else
            { off = _: { }; };
        hotkey-overlay.skip-at-startup = _: { };
        prefer-no-csd = _: { };
        input = {
          focus-follows-mouse = _: { };
          keyboard = {
            xkb = {
              layout = "us,ru";
              options = "grp:caps_toggle";
            };
          };
          touchpad = {
            natural-scroll = _: { };
            tap = _: { };
          };
          mouse =
            let
              cfg = config.preferences.mouse;
            in
            lib.filterAttrs (_: v: v != null) {
              inherit (cfg) accel-profile accel-speed scroll-factor;
              natural-scroll = if cfg.natural-scroll then (_: { }) else null;
            };
        };
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        layout = {
          always-center-single-column = _: { };
          gaps = 16;
          focus-ring = {
            width = 2;
          };
          struts = {
            left = 1;
            right = 1;
            top = 1;
            bottom = 0;
          };
        };
        window-rule =
          let
            cfg = config.preferences.ui;
          in
          {
            background-effect = {
              blur = cfg.blur.enable;
            }
            // lib.optionalAttrs (cfg.blur.enable && cfg.opacity < 1.0) {
              xray = false;
            };
            geometry-corner-radius = cfg.corner.radius;
            clip-to-geometry = true;
          };
        window-rules = config.preferences.wm.rules.windows;
        layer-rules = config.preferences.wm.rules.layers;
        binds =
          let
            toContent =
              action:
              if builtins.isList action then
                { spawn = map (a: if lib.isDerivation a then lib.getExe a else a) action; }
              else if lib.isDerivation action then
                { spawn = [ (lib.getExe action) ]; }
              else
                { spawn-sh = action; };

            toBind =
              { action, allowLocked }:
              let
                content = toContent action;
              in
              if allowLocked == null then
                content
              else
                (_: {
                  props = {
                    allow-when-locked = allowLocked;
                  };
                  inherit content;
                });
            niriBinds = lib.mapAttrs (_: toBind) config.preferences.binds;
          in
          {
            "Mod+Q".close-window = _: { };
            "Mod+F".maximize-column = _: { };
            "Mod+G".fullscreen-window = _: { };
            "Mod+Shift+F".toggle-window-floating = _: { };
            "Mod+C".center-column = _: { };

            "Mod+H".focus-column-left = _: { };
            "Mod+L".focus-column-right = _: { };
            "Mod+K".focus-window-up = _: { };
            "Mod+J".focus-window-down = _: { };

            "Mod+Left".focus-column-left = _: { };
            "Mod+Right".focus-column-right = _: { };
            "Mod+Up".focus-window-up = _: { };
            "Mod+Down".focus-window-down = _: { };

            "Mod+WheelScrollDown".focus-column-left = _: { };
            "Mod+WheelScrollUp".focus-column-right = _: { };
            "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: { };
            "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: { };

            "Mod+Shift+H".move-column-left = _: { };
            "Mod+Shift+L".move-column-right = _: { };
            "Mod+Shift+K".move-window-up = _: { };
            "Mod+Shift+J".move-window-down = _: { };

            "Mod+Shift+Left".move-column-left = _: { };
            "Mod+Shift+Right".move-column-right = _: { };
            "Mod+Shift+Up".move-window-up = _: { };
            "Mod+Shift+Down".move-window-down = _: { };

            "Mod+Ctrl+H".set-column-width = "-5%";
            "Mod+Ctrl+L".set-column-width = "+5%";
            "Mod+Ctrl+K".set-window-height = "+5%";
            "Mod+Ctrl+J".set-window-height = "-5%";

            "Mod+Ctrl+Left".set-column-width = "-5%";
            "Mod+Ctrl+Right".set-column-width = "+5%";
            "Mod+Ctrl+Up".set-window-height = "+5%";
            "Mod+Ctrl+Down".set-window-height = "-5%";

            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;

            "Mod+Shift+1".move-column-to-workspace = 1;
            "Mod+Shift+2".move-column-to-workspace = 2;
            "Mod+Shift+3".move-column-to-workspace = 3;
            "Mod+Shift+4".move-column-to-workspace = 4;
            "Mod+Shift+5".move-column-to-workspace = 5;
            "Mod+Shift+6".move-column-to-workspace = 6;
            "Mod+Shift+7".move-column-to-workspace = 7;
            "Mod+Shift+8".move-column-to-workspace = 8;
            "Mod+Shift+9".move-column-to-workspace = 9;

            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

            "Print".spawn-sh = "niri msg action screenshot-screen";
            "Alt+Print".spawn-sh = "niri msg action screenshot-window";
            "Ctrl+Print".spawn-sh = "niri msg action screenshot";
            "Mod+Shift+S".spawn-sh = "niri msg action screenshot";

            "Mod+Shift+E".spawn-sh = "${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -";
          }
          // niriBinds;
        extraConfig =
          let
            renderOutput = port: mon: ''
              output "${port}" {
                ${
                  if !mon.enable then
                    "off"
                  else
                    ''
                      mode ${mon.width}x${mon.height}${
                        lib.optionalString (mon.refreshRate != null) "@${toString mon.refreshRate}"
                      }
                      ${lib.optionalString (
                        mon.position != null
                      ) "postion x=${toString mon.position.x} y=${toString mon.position.y}"}
                      ${lib.optionalString mon.primary "focus-at-startup"}
                    ''
                }
              }
            '';
            monitorsConfig = lib.concatStrings (lib.mapAttrsToList renderOutput config.preferences.monitors);
          in
          ''
            ${monitorsConfig}

            animations {
              workspace-switch {
                spring damping-ratio=0.75 stiffness=1600 epsilon=0.0001
              }

              window-open {
                duration-ms 500
                curve "ease-out-cubic"
                custom-shader r"
                  vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                    float p = niri_clamped_progress;
                    vec2 uv = coords_geo.xy;
                    vec3 tc = niri_geo_to_tex * vec3(uv, 1.0);
                    vec4 win = texture2D(niri_tex, tc.st);
                    
                    vec2 dir = vec2(1.0, -1.0);
                    float smoothness = 0.5;
                    vec2 center = vec2(0.5, 0.5);
                    vec2 v = normalize(dir);
                    v /= abs(v.x) + abs(v.y);
                    float d = v.x * center.x + v.y * center.y;
                    float reveal = (1.0 - step(p, 0.0)) *
                        (1.0 - smoothstep(-smoothness, 0.0, v.x * uv.x + v.y * uv.y - (d - 0.5 + p * (1.0 + smoothness))));
                    
                    return win * reveal;
                  }
                "
              }

              window-close {
                duration-ms 500
                curve "ease-out-cubic"
                custom-shader r"
                vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                  float p = 1.0 - niri_clamped_progress;
                  vec2 uv = coords_geo.xy;
                  
                  float a = 4.0;
                  float b = 1.0;
                  float amplitude = 120.0;
                  float smoothness = 0.1;
                  vec2 dir = uv - vec2(0.5);
                  float dist = length(dir);
                  float xx = (a - b) * cos(p) + b * cos(p * ((a / b) - 1.0));
                  float yy = (a - b) * sin(p) - b * sin(p * ((a / b) - 1.0));
                  vec2 offset = dir * vec2(sin(p * dist * amplitude * xx), sin(p * dist * amplitude * yy)) / smoothness;
                  
                  vec3 tc = niri_geo_to_tex * vec3(uv, 1.0);
                  vec4 win = texture2D(niri_tex, tc.st);
                  
                  float reveal = smoothstep(0.2, 1.0, p);
                  return win * reveal;
                }
                "
              }

              horizontal-view-movement {
                spring damping-ratio=0.75 stiffness=800 epsilon=0.0003
              }

              window-movement {
                spring damping-ratio=0.6 stiffness=760 epsilon=0.0003
              }

              window-resize {
                spring damping-ratio=0.45 stiffness=750 epsilon=0.0001
              }

              overview-open-close {
                spring damping-ratio=0.40 stiffness=900 epsilon=0.001
              }

              recent-windows-close {
                spring damping-ratio=0.40 stiffness=900 epsilon=0.001
              }
            }
          '';
      };
    };
  };
}
