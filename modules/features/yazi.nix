{ self, ... }: {
  flake.nixosModules.yazi = { config, pkgs, lib, ... }: {
    environment.systemPackages = [
      pkgs.yazi
    ];
    home.files.".config/yazi/init.lua".text = ''
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
    home.files.".config/yazi/yazi.toml" = {
      generator = (pkgs.formats.toml { }).generate "yazi.toml";
      value = {
        mgr.linemode = "size_and_mtime";
      };
    };
    home.files.".config/yazi/theme.toml" = {
      generator = (pkgs.formats.toml { }).generate "theme.toml";
      value = 
      let
        block = { open = "█"; close = "█"; };
      in
        lib.optionalAttrs config.programs.noctalia.enable {
          flavor.dark = "noctalia";
          flavor.light = "noctalia";
        }
        // lib.optionalAttrs (config.preferences.ui.corner.radius == 0) {
          status.sep_left = block;
          status.sep_right = block;
          indicator.padding = block;
        };
    };
    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-termfilechooser
      ];
      config.common."org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
    };
    home.files.".config/xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
      env=PATH="$PATH:/run/current-system/sw/bin"
      open_mode=suggested
      save_mode=last
    '';
    xdg.mime.defaultApplications = {
      "inode/directory" = [ "yazi.desktop" ];
      "inode/mount-point" = [ "yazi.desktop" ];
    };
  };
}
