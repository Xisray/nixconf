{
  flake.nixosModules.yazi = {
    config,
    lib,
    pkgs,
    ...
  }: let
    style = config.appearance;
    hasScheme = style.scheme != null;
  in {
    homefs.files = let
      block = {
        open =
          if (style.rounding == 0)
          then "█"
          else "";
        close =
          if (style.rounding == 0)
          then "█"
          else "";
      };
      toTOML = pkgs.formats.toml {};
    in {
      ".config/yazi/init.lua".text = ''
        Status:children_add(function(self)
          local h = self._current.hovered
          if h and h.link_to then
            return " -> " .. tostring(h.link_to)
          else
            return ""
          end
        end, 3300, Status.LEFT)

        function Linemode:size_and_mtime()
          local time = math.floor(self._file.cha.mtime or 0)
          if time == 0 then
            time = ""
          elseif os.date("%Y", time) == os.date("%Y") then
            time = os.date("%b %d %H:%M", time)
          else
            time = os.date("%b %d  %Y", time)
          end
          local size = self._file:size()
          return string.format("%s %s", size and ya.readable_size(size) or "", time)
        end
      '';
      ".config/yazi/yazi.toml" = {
        value = {
          mgr.linemode = "size_and_mtime";
        };
        generator = toTOML.generate "yazi.toml";
      };
      ".config/yazi/flavors/nix.yazi/flavor.toml" = lib.mkIf hasScheme (
        style.colors {src = ./yazi.toml.mustache;}
      );
      ".config/yazi/flavors/nix.yazi/tmtheme.xml" = lib.mkIf hasScheme (
        style.colors {src = ../bat/bat.tmTheme.mustache;}
      );
      ".config/yazi/theme.toml" = {
        value = {
          flavor = lib.mkIf hasScheme {
            dark = "nix";
            light = "nix";
          };
          status.sep_left = block;
          status.sep_right = block;
          indicator.padding = block;
        };
        generator = toTOML.generate "theme.toml";
      };
    };
    xdg = {
      portal = {
        extraPortals = with pkgs; [
          xdg-desktop-portal-termfilechooser
        ];
        config = lib.genAttrs ["common" "sway" "hyprland" "niri" "gnome" "kde"] (_: {
          "org.freedesktop.impl.portal.FileChooser" = lib.mkForce "termfilechooser";
        });
      };
      mime.defaultApplications = {
        "inode/directory" = ["yazi.desktop"];
        "inode/mount-point" = ["yazi.desktop"];
      };
    };
    systemd.user.tmpfiles.rules = let
      termfilechooserConfig = pkgs.writeText "termfilechooser-config" ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        default_dir=$HOME
        env=PATH=$PATH:/run/current-system/sw/bin
        env=TERMCMD=${lib.getExe pkgs.xdg-terminal-exec} --app-id=termfilechooser
        open_mode=suggested
        save_mode=last
      '';
    in [
      "d %h/.config/xdg-desktop-portal-termfilechooser 0755 - - -"
      "L+ %h/.config/xdg-desktop-portal-termfilechooser/config - - - - ${termfilechooserConfig}"
    ];
    user.packages = [
      (pkgs.makeDesktopItem {
        name = "yazi";
        desktopName = "Yazi File Manager";
        genericName = "File Manager";
        comment = "Blazing fast terminal file manager written in Rust, based on async I/O";
        icon = "yazi";
        exec = "xdg-terminal-exec --app-id=yazi yazi %f";
        terminal = false;
        categories = [
          "System"
          "FileManager"
          "FileTools"
          "ConsoleOnly"
        ];
        mimeTypes = [
          "inode/directory"
          "inode/mount-point"
        ];
        extraConfig.Version = "1.5";
      })
    ];
    preferences.wm.rules.windows = [
      {
        match.app-id = "^termfilechooser$";
        open-floating = true;
        default-window-height.proportion = 0.6;
        default-column-width.proportion = 0.45;
      }
    ];
  };
}
