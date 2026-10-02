{
  flake.nixosModules.preferences = {
    config,
    lib,
    ...
  }: let
    cursor = config.preferences.theme.cursor;
  in {
    config = lib.mkIf (cursor != null) {
      environment = {
        systemPackages = lib.mkIf (cursor.package != null) [
          cursor.package
        ];
        sessionVariables = {
          XCURSOR_THEME = lib.mkIf (cursor.name != null) cursor.name;
          XCURSOR_SIZE = lib.mkIf (cursor.size != null) (toString cursor.size);
        };
      };
      home = {
        files.".icons/default/index.theme".text = lib.mkIf (cursor.name != null) ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${cursor.name}
        '';
        desktops.niri.settings.cursor = lib.mkForce {
          xcursor-theme = cursor.name;
          xcursor-size = cursor.size;
        };
        gtk.settings = {
          gtk-cursor-theme-name = cursor.name;
          gtk-cursor-theme-size = cursor.size;
        };
      };
    };
  };
}
