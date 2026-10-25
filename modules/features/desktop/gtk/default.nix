{
  flake.nixosModules.gtk = {
    pkgs,
    lib,
    config,
    ...
  }: let
    style = config.appearance;
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
    homefs.files.".config/gtk-3.0/gtk.css" = lib.mkIf (style.scheme != null) (style.colors {src = ./gtk3.css.mustache;});
    homefs.files.".config/gtk-4.0/gtk.css" = lib.mkIf (style.scheme != null) (style.colors {src = ./gtk4.css.mustache;});

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
