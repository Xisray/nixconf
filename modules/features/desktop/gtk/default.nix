{
  flake.nixosModules.gtk = {
    pkgs,
    lib,
    config,
    ...
  }: let
    style = config.appearance;
    css =
      if style.scheme == null
      then null
      else
        lib.genAttrs ["3.0" "4.0"] (v:
          style.colors {
            src = ./. + "/gtk${builtins.head (lib.splitString "." v)}.css.mustache";
          });
  in {
    environment.systemPackages = [
      pkgs.adw-gtk3
    ];

    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config.common.default = ["gtk"];
    };

    systemd.user.tmpfiles.rules = lib.mkIf (css != null) (lib.mapAttrsToList (v: path: "L+ %h/.config/gtk-${v}/gtk.css - - - - ${path}") css);
    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings."org/gnome/desktop/interface" =
            {
              gtk-theme =
                if style.polarity == "dark"
                then "adw-gtk3-dark"
                else "adw-gtk3";
              font-name = "${style.fonts.sansSerif.name} ${toString style.fonts.sizes.applications}";
              color-scheme = "prefer-${style.polarity}";
            }
            // lib.optionalAttrs (style.icons != null) {
              icon-theme = style.icons.${style.polarity};
            }
            // lib.optionalAttrs (style.cursor != null) {
              cursor-theme = style.cursor.name;
              cursor-size = lib.gvariant.mkUint32 style.cursor.size;
            };
        }
      ];
    };
  };
}
