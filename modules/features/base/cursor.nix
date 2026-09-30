{
  flake.nixosModules.preferences = {
    config,
    lib,
    ...
  }: let
    cursor = config.preferences.cursor;
  in {
    environment = lib.mkIf (cursor != null) {
      systemPackages = lib.mkIf (cursor.package != null) [
        cursor.package
      ];
      sessionVariables = {
        XCURSOR_THEME = lib.mkIf (cursor.name != null) cursor.name;
        XCURSOR_SIZE = lib.mkIf (cursor.size != null) (toString cursor.size);
      };
    };
    home.files.".icons/default/index.theme".text = lib.mkIf (cursor.name != null) ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=${cursor.name}
    '';
  };
}
