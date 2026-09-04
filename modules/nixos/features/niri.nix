{ self, inputs, ... }: {
  flake.nixosModules.niri =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      toCmd = entry: if lib.isDerivation entry then lib.getExe entry else entry;
      toContent = action: if builtins.isList action then { spawn = action; } else { spawn-sh = action; };
      toBind =
        { action, props }:
        let
          content = toContent action;
        in
        if props == { } then content else (_: { inherit props content; });

      user = config.preferences.user.name;
      hmPreferences = config.home-manager.users.${user}.preferences;

      hmAutostart = hmPreferences.autostart or [ ];
      autostart = config.preferences.autostart ++ hmAutostart;

      hmBinds = hmPreferences.binds or { };
      allBinds = config.preferences.binds // hmBinds;
      niriBinds = lib.mapAttrs (_: toBind) allBinds;
    in
    {
      programs.niri = {
        enable = true;
        package = inputs.wrapper-modules.wrappers.niri.wrap {
          inherit pkgs;
          settings = {
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
            };
            spawn-at-startup = map toCmd autostart;
            xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
            layout = {
              always-center-single-column = _: { };
              gaps = 16;
              focus-ring = {
                width = 2;
                active-color = self.theme.base07;
              };
              struts = {
                left = 2;
                right = 2;
                top = 2;
                bottom = 0;
              };
            };
            window-rule = {
              # geometry-corner-radius = 12;
              # clip-to-geometry = true;
            };
            binds = niriBinds // {
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
            };
            extraConfig = ''
              animations {
                // Uncomment to turn off all animations.
                //off
                workspace-switch {
                  spring damping-ratio=0.75 stiffness=1600 epsilon=0.0001
                }

                window-open {
                  spring damping-ratio=0.5 stiffness=1000 epsilon=0.0003
                  //curve "ease-out-expo"
                }

              window-close {
                  duration-ms 200
                  curve "linear"
                  custom-shader r"
                  // ── Easing ────────────────────────────────────────────────────────
                  float easeInExpo(float t)   { return t == 0.0 ? 0.0 : pow(2.0, 10.0 * (t - 1.0)); }
                  float easeOutQuad(float t)  { return 1.0 - (1.0 - t) * (1.0 - t); }
                  float easeInQuad(float t)   { return t * t; }
                  float easeOutCubic(float t) { float f = t - 1.0; return f * f * f + 1.0; }
                  float easeInQuart(float t)  { return t * t * t * t; }

                  float saturate(float x) {
                      return clamp(x, 0.0, 1.0);
                  }

                  float remap(float t, float a, float b) {
                      return saturate((t - a) / (b - a));
                  }

                  vec2 scaleUV(vec2 uv, vec2 scale) {
                      return (uv - 0.5) / scale + 0.5;
                  }

                  float centerGradient(float x) {
                      x *= 2.0;
                      return x < 1.0 ? x : 2.0 - x;
                  }

                  vec2 barrelDistort(vec2 uv, float strength) {
                      vec2 cc = uv - 0.5;
                      float dist = dot(cc, cc);
                      return uv + cc * dist * strength;
                  }

                  vec4 close_color(vec3 coords_geo, vec3 size_geo) {

                      if (coords_geo.x < 0.0 || coords_geo.x > 1.0 ||
                          coords_geo.y < 0.0 || coords_geo.y > 1.0)
                          return vec4(0.0);

                      vec2 uv = (niri_geo_to_tex * coords_geo).xy;

                      if (uv.x < 0.0 || uv.x > 1.0 ||
                          uv.y < 0.0 || uv.y > 1.0)
                          return vec4(0.0);

                      float p = niri_clamped_progress;
                      float inv = 1.0 - p;

                      // Horizontal collapses slightly after vertical for a CRT feel.
                      float py = remap(inv, 0.30, 1.00);
                      float px = remap(inv, 0.00, 0.80);

                      float scaleX = mix(0.06, 1.0, easeOutCubic(px));
                      float scaleY = mix(0.00, 1.0, easeInQuad(py));

                      float barrelStr = (1.0 - easeOutQuad(px)) * 0.20;
                      vec2 distortedUV = barrelDistort(uv, barrelStr);

                      vec2 sampleUV = scaleUV(distortedUV, vec2(scaleX, scaleY));

                      if (sampleUV.x < 0.0 || sampleUV.x > 1.0 ||
                          sampleUV.y < 0.0 || sampleUV.y > 1.0)
                          return vec4(0.0);

                      vec4 color = texture2D(niri_tex, sampleUV);

                      float edgeSoft = mix(0.14, 0.04, easeInQuad(p));

                      float tb = centerGradient(sampleUV.y);
                      float lr = centerGradient(sampleUV.x);

                      float mask =
                          smoothstep(0.0, edgeSoft, tb) *
                          smoothstep(0.0, edgeSoft, lr);

                      color.a *= mask;
                      color *= easeOutQuad(inv);

                      color *= 1.0 - easeInQuart(remap(p, 0.90, 1.00));

                      return color;
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

                // Slow down all animations by this factor. Values below 1 speed them up instead
                slowdown 1.3
              }
            '';
          };
        };
      };
    };
}
