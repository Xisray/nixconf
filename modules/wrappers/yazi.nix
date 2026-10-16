{
  flake.wrappers.yazi = {
    wlib,
    config,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.yazi];
    runtimePkgs = [
      pkgs.wl-clipboard
    ];
    settings.yazi.mgr.linemode = "size_and_mtime";
    constructFiles = {
      initLua = {
        relPath = "${config.binName}-config/init.lua";
        output = config.generatedConfig.output;
        content = ''
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
      };
      yazi-desktop = {
        relPath = "share/applications/yazi.desktop";
        content = ''
          [Desktop Entry]
          Version=1.5
          Type=Application
          Name=Yazi File Manager
          GenericName=File Manager
          Comment=Blazing fast terminal file manager written in Rust, based on async I/O
          Icon=yazi
          Exec=xdg-terminal-exec --app-id=yazi yazi %f
          Terminal=false
          Categories=System;FileManager;FileTools;ConsoleOnly;
          MimeType=inode/directory;inode/mount-point;
        '';
      };
    };
  };
}
