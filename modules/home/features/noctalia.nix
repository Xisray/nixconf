{
  flake.homeModules.noctalia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      colors = config.lib.stylix.colors.withHashtag;
      colorList = with colors; [
        base00
        base01
        base02
        base03
        base04
        base05
        base06
        base07
        base08
        base09
        base0A
        base0B
        base0C
        base0D
        base0E
        base0F
      ];
      paletteHash = builtins.hashString "sha256" (lib.concatStringsSep "" colorList);
      haldClut =
        pkgs.runCommand "stylix-hald-clut.png"
          {
            nativeBuildInputs = [ pkgs.lutgen ];
          }
          ''
            lutgen generate -o $out -- ${lib.escapeShellArgs colorList}
          '';
      recolorScript = pkgs.writeShellApplication {
        name = "noctalia-recolor-wallpaper";
        runtimeInputs = with pkgs; [
          lutgen
          coreutils
          findutils
          gnused
        ];
        text = ''
          set -euo pipefail

          original="''${1:-}"
          screen="''${2:-}"

          if [[ -z "$original" ]]; then
            echo "noctalia-recolor: no wallpaper path provided" >&2
            exit 1
          fi

          if [[ "$original" == color:* ]] || [[ "$original" == *"/recolored/"* ]]; then
            exit 0
          fi

          if [[ ! -f "$original" ]]; then
            echo "noctalia-recolor: file not found: $original" >&2
            exit 1
          fi

          out="$(mktemp --suffix=.png)"
          trap 'rm -f "$out"' EXIT

          lutgen apply --hald-clut ${haldClut} "$original" -o "$out" 

          if [[ -n "$screen" ]]; then
            noctalia msg wallpaper-set "$screen" "$out"
          else
            noctalia msg wallpaper-set "$out"
          fi
        '';
      };
    in
    {
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
          hooks.wallpaper_changed = lib.mkIf config.stylix.enable "${recolorScript}/bin/noctalia-recolor-wallpaper $NOCTALIA_WALLPAPER_PATH $NOCTALIA_WALLPAPER_CONNECTOR";
          desktop_widgets.enabled = false;
          dock.enabled = false;
          shell = {
            password_style = "random";
            polkit_agent = true;
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
            tray.drawer = true;
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

          wallpaper.directory = "~/Pictures/Wallpapers";
          shell.panel.open_near_click_control_center = true;
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
